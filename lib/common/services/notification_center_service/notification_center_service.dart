import 'dart:async';
import 'dart:io';

import 'package:hh_example/common/config/config_service.dart';
import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/models/helpers/config/config_state_model.dart';
import 'package:hh_example/common/models/version/version.dart';
import 'package:hh_example/common/services/analytics/analytics_event.dart';
import 'package:hh_example/common/services/notification_center_service/notification_center_state.dart';
import 'package:hh_example/common/services/notification_service/notification_notifier.dart';
import 'package:hh_example/common/utils/extensions/analytics/ref_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'notification_center_service.g.dart';

@riverpod
class NotificationCenterService extends _$NotificationCenterService {
  PackageInfo get _packageInfo => ref.read(packageInfoProvider);

  ConfigStateModel get _config => ref.read(configServiceProvider);

  NotificationNotifier get _notification => ref.read(notificationNotifierProvider.notifier);

  StreamSubscription<ServiceStatus>? _serviceStatusStream;

  @override
  NotificationCenterState build() {
    ref.listenSelf((p, n) {
      /// Отправка запроса токена FCM, если изменилось необходимость разрешения уведомлений
      if (p?.warningNotification == true && !n.warningNotification) {
        _notification.updateFCMToken();
      }
    });

    ref.onDispose(() {
      _serviceStatusStream?.cancel();
    });

    return const NotificationCenterState();
  }

  Future<void> init() async {
    /// Отслеживание изменения состояния GPS
    _serviceStatusStream = Geolocator.getServiceStatusStream().listen((status) async {
      state = state.copyWith(
        warningGps: await _getShowGps(serviceEnabled: status == ServiceStatus.enabled),
      );
    });

    await updateState();
  }

  Future<void> updateState() async {
    state = state.copyWith(
      warningAppUpdate: await _showAppUpdate(),
      warningNotification: await _showNotification(),
      warningGps: await _getShowGps(),
    );
  }

  Future<void> actionByType(NotificationCenterWarningType type) async {
    switch (type) {
      case NotificationCenterWarningType.appUpdate:
        await transitionToStore();
        break;
      case NotificationCenterWarningType.notification:
        await requestNotificationPermission();
        break;
      case NotificationCenterWarningType.gps:
        await requestGpsPermission();
        break;
      default:
        break;
    }
  }

  /// Проверка обновлений МП
  Future<void> transitionToStore() async {
    final config = ref.read(configServiceProvider);

    /// Отправка события в аналитику
    ref.analytics.logEvent(AnalyticsEvent.goToVersionUpdate());

    await launchUrlString(Platform.isIOS ? config.appStoreUrl : config.googlePlayUrl);
  }

  /// Запрос разрешения [Permission.notification]
  Future<void> requestNotificationPermission() async {
    await _sequentialPermissionRequest(
      p.Permission.notification,
      customRequest: () async {
        await FirebaseMessaging.instance.requestPermission();

        return p.Permission.notification.isGranted;
      },
      onPositiveResultRequest: () async {
        /// Отправка события в аналитику
        ref.analytics.logEvent(AnalyticsEvent.pushesEnabled());
      },
      onNegativeResultRequest: () async {
        /// Отправка события в аналитику
        ref.analytics.logEvent(AnalyticsEvent.pushesDisabled());
      },
      onGoToSettings: () async {
        /// Отправка события в аналитику
        ref.analytics.logEvent(AnalyticsEvent.pushesGoToSettings());
      },
    );

    state = state.copyWith(
      warningNotification: await _showNotification(),
    );
  }

  /// Запрос на включение GPS
  /// Запрос разрешения [Permission.locationWhenInUse]
  Future<void> requestGpsPermission() async {
    /// Открываются настройки геолокации
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
    }

    await _sequentialPermissionRequest(
      p.Permission.locationWhenInUse,
      onPositiveResultRequest: () async {
        /// Отправка события в аналитику
        ref.analytics.logEvent(AnalyticsEvent.gpsEnabled());
      },
      onNegativeResultRequest: () async {
        /// Отправка события в аналитику
        ref.analytics.logEvent(AnalyticsEvent.gpsDisabled());
      },
      onGoToSettings: () async {
        /// Отправка события в аналитику
        ref.analytics.logEvent(AnalyticsEvent.gpsGoToSettings());
      },
    );

    state = state.copyWith(
      warningGps: await _getShowGps(),
    );
  }

  /// Последовательный запрос разрешения
  /// [permission] - Тип разрешения
  /// [customRequest] - Замена стандартного запроса разрешения
  /// [onPositiveResult] - Действие при успешном запросе разрешения
  Future<bool> _sequentialPermissionRequest(
    p.Permission permission, {
    Future<bool> Function()? customRequest,
    Future<void> Function()? onPositiveResultRequest,
    Future<void> Function()? onNegativeResultRequest,
    Future<void> Function()? onGoToSettings,
  }) async {
    bool result = false;
    if (await permission.isDenied) {
      /// Запрос разрешения
      if (customRequest != null) {
        result = await customRequest();
      } else {
        result = p.PermissionStatus.granted == await permission.request();
      }

      if (result) {
        await onPositiveResultRequest?.call();
      } else {
        await onNegativeResultRequest?.call();
      }
    } else if (await permission.isPermanentlyDenied) {
      await onGoToSettings?.call();

      /// Переход в настройки МП
      await Geolocator.openAppSettings();
    }

    return result;
  }

  /// Проверка версии МП
  Future<bool> _showAppUpdate() async {
    final currentVersion = _packageInfo.version;
    final lastVersion = Platform.isIOS ? _config.versionIos : _config.versionAndroid;

    return Version.parse(currentVersion) < Version.parse(lastVersion);
  }

  Future<bool> _showNotification() async {
    return !await p.Permission.notification.isGranted;
  }

  /// [serviceEnabled] - Когда не нужно запрашивать состояние GPS
  Future<bool> _getShowGps({bool? serviceEnabled}) async {
    final permissionGranted = await p.Permission.locationWhenInUse.isGranted;
    serviceEnabled ??= await Geolocator.isLocationServiceEnabled();

    return !permissionGranted || !serviceEnabled;
  }
}
