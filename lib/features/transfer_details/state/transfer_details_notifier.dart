import 'dart:async';

import 'package:hh_example/common/config/config_service.dart';
import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/logs/logs.dart';
import 'package:hh_example/common/models/helpers/config/config_state_model.dart';
import 'package:hh_example/common/models/markers/marker_with_transfer_place.dart';
import 'package:hh_example/common/models/navigator_type/navigator_types.dart';
import 'package:hh_example/common/models/profile/profile_model.dart';
import 'package:hh_example/common/models/task/task_update_request.dart';
import 'package:hh_example/common/models/task/tasks.dart';
import 'package:hh_example/common/models/task_status/task_statuses.dart';
import 'package:hh_example/common/providers/local_settings/local_settings_abstraction.dart';
import 'package:hh_example/common/providers/local_settings/local_settings_provider.dart';
import 'package:hh_example/common/providers/task/tasks_abstraction.dart';
import 'package:hh_example/common/providers/task/tasks_provider.dart';
import 'package:hh_example/common/services/analytics/analytics_event.dart';
import 'package:hh_example/common/services/location/location_service.dart';
import 'package:hh_example/common/services/notification_center_service/notification_center_service.dart';
import 'package:hh_example/common/services/notification_center_service/notification_center_state.dart';
import 'package:hh_example/common/services/profile_service/profile_service.dart';
import 'package:hh_example/common/services/url_launcher_service.dart';
import 'package:hh_example/common/utils/extensions/analytics/ref_analytics.dart';
import 'package:hh_example/common/utils/extensions/ref_keep_providers_extension.dart';
import 'package:hh_example/common/utils/symbolic_naming.dart';
import 'package:hh_example/features/transfer_details/state/transfer_details_state.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:hh_example/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transfer_details_notifier.g.dart';

@riverpod
class TransferDetailsNotifier extends _$TransferDetailsNotifier {
  ITasks get _tasksProvider => ref.read(tasksProvider);

  UrlLauncherService get _urlService => ref.read(urlLauncherServiceProvider.notifier);

  ConfigStateModel get _config => ref.read(configServiceProvider);

  ILocalSettings get _localSettings => ref.read(localSettingsProvider);

  NotificationCenterService get _notificationService =>
      ref.read(notificationCenterServiceProvider.notifier);

  NotificationCenterState get _notificationServiceModel =>
      ref.read(notificationCenterServiceProvider);

  LocationService get _location => ref.read(locationServiceProvider.notifier);

  AsyncValue<ProfileModel> get _profile => ref.read(profileServiceProvider);

  Logs get _logs => ref.read(loggerProvider);

  Timer? _actionRestrictionsTimer;
  var _data = const TransferDetailsData(loading: true);
  final fakeTask = Task.fake();

  @override
  TransferDetailsState build() {
    ref.keepProvider(tasksProvider);

    ref.onDispose(() {
      _actionRestrictionsTimer?.cancel();
    });

    return TransferDetailsState.main(_data);
  }

  /// Получение первоначальных данных
  Future<void> init(int id, {required AppLocalizations loc}) async {
    _setMainStateWithLoading(true);

    try {
      await _checkTask(id);

      await _uploadTaskData(id, loc: loc);

      _setTimerActionRestrictions();

      await _setCameraUpdateState();
      _setMainState();
    } catch (e, s) {
      _logs.e(e, e, s);
    }

    try {
      await _firstOpenTask(loc: loc);
    } catch (e, s) {
      _logs.e(e, e, s);
    }

    _setMainStateWithLoading();
  }

  /// Водитель первый раз открыл задачу
  /// Для всех трансферов со статусом [TaskStatus.newStatus]
  /// устанавливается новый статус [TaskStatus.opened]
  Future<void> _firstOpenTask({
    required AppLocalizations loc,
  }) async {
    final transfers = _data.requiredTask.nextTransfersForOpened;

    if (transfers.isEmpty) {
      return;
    }

    for (final t in transfers) {
      await _updateTask(id: t.id, status: TaskStatus.opened, loc: loc);
    }
  }

  /// Начать поездку
  /// Последовательно для каждого трансфера со статусом [TaskStatus.opened]
  /// меняются параметры [Transfer.driverToPickUp] = true
  /// Все трансферы за вызов функции
  Future<void> startTrip({
    required AppLocalizations loc,
  }) async {
    _setMainStateWithLoading(true);
    try {
      /// Если пользователь зашёл без разрешения на местоположение
      /// то сначала все трансферы отметятся  просмотренными
      await _firstOpenTask(loc: loc);

      final transfers = _data.requiredTask.nextTransfersForStarted;

      for (final t in transfers) {
        await _updateTask(id: t.id, status: t.status, driverToPickUp: true, loc: loc);
      }

      /// Отправка события в аналитику
      final ids = transfers.map((e) => e.id);
      ref.analytics.logEvent(AnalyticsEvent.setStatusOnRoute(
        datetime: _data.requiredTask.datetime,
        transferIds: ids,
      ));
    } catch (e, s) {
      _logs.e(e, e, s);
    }
    _setMainStateWithLoading();
  }

  /// Водитель приехал на место встречи
  /// Трансферу(ам) со статусом [TaskStatus.opened] и [Transfer.driverToPickUp] == true
  /// устанавливается флаг [Transfer.driverWaiting] = true
  /// Один или несколько трансферов за вызов функции,
  /// т.к. место встречи может быть одно для всех трансферов
  Future<void> driverArrived({
    required AppLocalizations loc,
  }) async {
    _setMainStateWithLoading(true);
    try {
      /// Получение списка трансферов с ближайшим местом встречи
      final transfers = _data.requiredTask.nextTransfersForDriverArrived;

      await _checkDistance(transfers.first.pickUp);

      for (final t in transfers) {
        await _updateTask(
          id: t.id,
          status: t.status,
          driverToPickUp: true,
          driverWaiting: true,
          loc: loc,
        );
      }

      /// Отправка события в аналитику
      final ids = transfers.map((e) => e.id);
      ref.analytics.logEvent(AnalyticsEvent.setStatusArrived(
        datetime: _data.requiredTask.datetime,
        transferIds: ids,
      ));
    } catch (e, s) {
      _logs.e(e, e, s);
    }
    _setMainStateWithLoading();
  }

  /// Водитель посадил на борт пассажира(ов)
  /// Трансферу(ам) со статусом [TaskStatus.opened] и [Transfer.driverWaiting] == true
  /// меняеются флаги [Transfer.clientOnBoard] = true
  /// Один или несколько трансферов за вызов функции,
  /// т.к. место встречи может быть одно для всех трансферов
  Future<void> clientOnBoard({
    required AppLocalizations loc,
  }) async {
    _setMainStateWithLoading(true);
    try {
      final transfers = _data.requiredTask.nextTransfersForClientOnBoard;

      await _checkDistance(transfers.first.pickUp);

      for (final t in transfers) {
        await _updateTask(
          id: t.id,
          status: TaskStatus.started,
          driverToPickUp: true,
          driverWaiting: true,
          clientOnBoard: true,
          loc: loc,
        );
      }

      /// Отправка события в аналитику
      final ids = transfers.map((e) => e.id);
      ref.analytics.logEvent(AnalyticsEvent.setStatusCustomerOnBoard(
        datetime: _data.requiredTask.datetime,
        transferIds: ids,
      ));
    } catch (e, s) {
      _logs.e(e, e, s);
    }
    _setMainStateWithLoading();
  }

  /// Завершение трансфера(ов)
  /// Трансферу(ам) со статусом [TaskStatus.started] и [Transfer.clientOnBoard] == true
  /// меняются параметры [TaskStatus.finished]
  /// Один или несколько трансферов за вызов функции,
  /// т.к. место высадки может быть одно для всех трансферов
  Future<void> completeTransfer({
    required AppLocalizations loc,
  }) async {
    _setMainStateWithLoading(true);
    try {
      /// Получение списка трансферов с ближайшим местом высадки
      var transfers = _data.requiredTask.nextTransfersForComplete;

      await _checkDistance(transfers.first.dropOff);

      for (final t in transfers) {
        await _updateTask(
          id: t.id,
          status: TaskStatus.finished,
          driverToPickUp: true,
          driverWaiting: true,
          clientOnBoard: true,
          loc: loc,
        );
      }

      /// Отправка события в аналитику
      final ids = transfers.map((e) => e.id);
      ref.analytics.logEvent(AnalyticsEvent.setStatusCompleted(ids));

      transfers = _data.requiredTask.nextTransfersForComplete;

      /// Когда задания на завершение не осталось, то можно выходить со страницы
      if (transfers.isEmpty) {
        _setWarningSuccessfully();
      }
    } catch (e, s) {
      _logs.e(e, e, s);
    }
    _setMainStateWithLoading();
  }

  /// Переход к звонилке
  Future<void> callPassenger(Transfer transfer) async {
    try {
      _checkDateTime();

      final phone = transfer.contactNumber;
      _urlService.callTo(phone);

      /// Отправка события в аналитику
      ref.analytics.logEvent(AnalyticsEvent.callClient(_profile.value?.id));
    } catch (e, s) {
      _logs.e(e, e, s);
    }
  }

  /// Переход к навигатору
  Future<void> goToNavigator({NavigatorType? navigator}) async {
    try {
      final currentNavigator = navigator ?? _localSettings.getNavigatorType();

      if (currentNavigator == NavigatorType.askEveryTime) {
        _setSelectNavigatorState();
        _setMainState();
        return;
      }

      await currentNavigator.showDirectionsFromTaskOnlyFirstPlace(
        _data.requiredTask,
      );

      /// Отправка события в аналитику
      ref.analytics.logEvent(AnalyticsEvent.openNavigator());
    } catch (e, s) {
      _logs.e(e, e, s);
    }
  }

  /// Запрос разрешения GPS
  Future<void> requestGpsPermission() => _notificationService.requestGpsPermission();

  /// Проверка доступности по времени
  bool checkDateTime() {
    try {
      _checkDateTime();
    } catch (e, s) {
      _logs.e(e, e, s);
      return false;
    }

    return true;
  }

  /// Проверка доступности по времени
  void _checkDateTime() {
    if (!_data.checkActionRestrictions()) {
      throw 'Time does not allow';
    }
  }

  /// Проверка дистанции до точки
  Future<void> _checkDistance(TransferPlace place) async {
    if (!place.hasCoordinates) {
      // TODO(alexanderkind): Можно прерывать при отсутствии координт
      return;
      throw 'The place has no coordinates';
    }

    /// Ошибка по GPS
    _checkGps();

    final distance = await _location.distanceBetweenCurrentPosition(place.lat!, place.lng!);
    final maxDistance = _config.minDistanceToPoint;

    /// Ошибка по дистрации до точки
    if (distance > maxDistance) {
      if (_data.requiredTask.pickUpCorrectPlaces.contains(place)) {
        _setWarningFarFromPickUpState();
      } else {
        _setWarningFarFromDropOffState();
      }
      _setMainState();
      throw 'Far from the point';
    }
  }

  /// Проверка GPS
  void _checkGps() {
    if (_notificationServiceModel.warningGps) {
      _setWarningLocationState();
      _setMainState();
      throw 'GPS permission required';
    }
  }

  /// Проверка задачи
  Future<void> _checkTask(int id) async {
    final task = await _tasksProvider.getTaskByTransferId(id);

    if (task == null) {
      _setExitState();
      throw 'The task is missing';
    }

    /// Отправка события в аналитику
    ref.analytics.logEvent(AnalyticsEvent.orderView(task.transferIds));
  }

  /// Обновление задачи, изменение статусов
  Future<void> _updateTask({
    required int id,
    required TaskStatus status,
    bool driverToPickUp = false,
    bool driverWaiting = false,
    bool clientOnBoard = false,
    required AppLocalizations loc,
  }) async {
    _checkGps();

    final position = await _location.getCurrentPosition();

    var task = await _tasksProvider.updateTask(TaskUpdateRequest(
      transferId: id,
      status: status,
      driverToPickUp: driverToPickUp,
      driverWaiting: driverWaiting,
      clientOnBoard: clientOnBoard,
      currentLat: position.latitude,
      currentLng: position.longitude,
    ));

    /// Перенос полученных через геокодинг при инициализации страницы точек
    /// в трансферы обновлённого задания
    /// Это сделано, чтобы лишний раз не обращаться к платному геокодинку
    if (task?.hasProblems == true) {
      final oldTransfers = _data.task?.data;
      final newTransfers = task?.data;
      if (oldTransfers != null &&
          newTransfers != null &&
          oldTransfers.length == newTransfers.length) {
        task = task?.copyWith(
          data: List.generate(newTransfers.length, (index) {
            final ot = oldTransfers[index];
            var nt = newTransfers[index];

            return nt.copyWith(
              pickUp: nt.pickUp.hasCoordinates ? nt.pickUp : ot.pickUp,
              dropOff: nt.dropOff.hasCoordinates ? nt.dropOff : ot.dropOff,
            );
          }),
        );
      }
    }

    await _updateMapData(task, loc: loc, updatePolylines: true);
    // TODO(alexanderkind): Вернуть, если необходимо менять видимую область в зависимости от этапа
    //await _setCameraUpdateState();
    _setMainState();
  }

  /// Полный перерасчёт данных по задаче
  Future<void> _uploadTaskData(int id, {required AppLocalizations loc}) async {
    var task = await _tasksProvider.getTaskByTransferId(id);

    if (task == null) {
      return;
    }

    /// Получение координат по точкам при их отсутствии
    final transfers = <Transfer>[];
    for (final t in task.data) {
      if (t.pickUp.hasCoordinates && t.dropOff.hasCoordinates) {
        transfers.add(t);
        continue;
      }

      /// Приоритет получения координат
      /// Точка -> Запасная точка -> Геокодинг
      var pickUp = t.pickUp;
      if (!pickUp.hasCoordinates) {
        pickUp = t.pickUpWithBackupCoordinates;
      }
      if (!pickUp.hasCoordinates) {
        try {
          final g = await _location.geocodingFirstGeometry(pickUp.priorityAddress);
          pickUp = pickUp.copyWith(lat: g?.lat, lng: g?.lng);
        } catch (e, s) {
          _logs.e(e, e, s);
        }
      }

      /// Приоритет получения координат
      /// Точка -> Запасная точка -> Геокодинг
      var dropOff = t.dropOff;
      if (!dropOff.hasCoordinates) {
        dropOff = t.dropOffWithBackupCoordinates;
      }
      if (!dropOff.hasCoordinates) {
        try {
          final g = await _location.geocodingFirstGeometry(dropOff.priorityAddress);
          dropOff = dropOff.copyWith(lat: g?.lat, lng: g?.lng);
        } catch (e, s) {
          _logs.e(e, e, s);
        }
      }

      transfers.add(t.copyWith(pickUp: pickUp, dropOff: dropOff));
    }
    task = task.copyWith(data: transfers);

    /// Обновление данных карты
    await _updateMapData(task, loc: loc, updatePolylines: true);
  }

  Future<void> _updateMapData(
    Task? task, {
    required AppLocalizations loc,
    bool updatePolylines = false,
  }) async {
    if (task == null) {
      return;
    }

    final pickUpPlaces = task.pickUpCorrectPlaces;
    final pickUpMarkers = await Future.wait(List.generate(pickUpPlaces.length, (index) async {
      final p = pickUpPlaces[index];

      /// Определение активности маркера
      var active = [
            LocalTaskStatus.notStarted,
            LocalTaskStatus.onRoute,
            LocalTaskStatus.arrived,
            LocalTaskStatus.completed
          ].contains(task.localStatus) &&
          task.currentActivePlaces.contains(p);

      return createMarker(
        place: p,
        name: loc.commonPickUp,
        isPostfix: pickUpPlaces.length > 1,
        index: index,
        imageAssetPath: Assets.images.pickUpMapMarker,
        active: active,
      );
    }));

    final dropOffPlaces = task.dropOffCorrectPlaces;
    final dropOffMarkers = await Future.wait(List.generate(
      dropOffPlaces.length,
      (index) {
        final p = dropOffPlaces[index];

        var active = [
              LocalTaskStatus.notStarted,
              LocalTaskStatus.customerOnBoard,
              LocalTaskStatus.completed
            ].contains(task.localStatus) &&
            task.currentActivePlaces.contains(p);

        return createMarker(
          place: p,
          name: loc.commonDropOff,
          isPostfix: dropOffPlaces.length > 1,
          index: index,
          imageAssetPath: Assets.images.dropOffMapMarker,
          active: active,
        );
      },
    ));
    final markers = <MarkerWithTransferPlace>{...pickUpMarkers, ...dropOffMarkers};
    final start = markers.firstOrNull;
    final finish = dropOffMarkers.lastOrNull;
    final polylines = updatePolylines ? <Polyline>{} : _data.polylines;

    if (updatePolylines && start != null && finish != null && kReleaseMode) {
      final intermediateMarkers = markers.toList()
        ..remove(start)
        ..remove(finish);

      final wayPoints = [
        if (intermediateMarkers.isNotEmpty)
          ...intermediateMarkers.map(
              (e) => PolylineWayPoint(location: '${e.position.latitude} ${e.position.longitude}')),
      ];

      final polylinePoints = PolylinePoints();
      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: _config.mapKey,
        request: PolylineRequest(
          origin: PointLatLng(start.position.latitude, start.position.longitude),
          destination: PointLatLng(finish.position.latitude, finish.position.longitude),
          mode: TravelMode.driving,
          avoidFerries: true,
          avoidHighways: true,
          avoidTolls: true,
          wayPoints: wayPoints,
        ),
      );
      final polyline = Polyline(
        polylineId: const PolylineId('full_way'),
        color: const Color(0xFF231F26),
        points: result.points.map((p) => LatLng(p.latitude, p.longitude)).toList(),
        width: 6,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylines.add(polyline);
    }

    _data = _data.copyWith(
      task: task,
      markers: markers,
      polylines: polylines,
    );
  }

  Future<MarkerWithTransferPlace> createMarker({
    required TransferPlace place,
    required String name,
    required bool isPostfix,
    required int index,
    required SvgGenImage imageAssetPath,
    required bool active,
  }) async {
    return MarkerWithTransferPlace.createMapMarker(
      marker: MarkerWithTransferPlace(
        place: place,
        markerId: MarkerId(place.name),
        position: LatLng(place.lat!, place.lng!),
      ),
      title: '$name${isPostfix ? ' ${createSymbolicNameByIndex(index)}' : ''}',
      imageAssetPath: imageAssetPath,
      active: active,
    );
  }

  /// Созданеи по необходимости таймера отложенного отображения действий
  void _setTimerActionRestrictions() {
    if (!checkDateTime()) {
      _actionRestrictionsTimer = Timer(_data.durationLeftActionRestrictions, () {
        _data = _data.copyWith(actionRestrictions: false);
        if (state is TransferDetailsStateMain) {
          _setMainState();
        }
      });
      _data = _data.copyWith(actionRestrictions: true);
    } else {
      _data = _data.copyWith(actionRestrictions: false);
    }
  }

  /// Методы изменения состояния
  void _setMainStateWithLoading([bool loading = false]) {
    _data = _data.copyWith(loading: loading);
    state = TransferDetailsState.main(_data);
  }

  void _setMainState() => state = TransferDetailsState.main(_data);

  void _setExitState() => state = const TransferDetailsState.exit();

  void _setSelectNavigatorState() => state = const TransferDetailsState.selectNavigator();

  Future<void> _setCameraUpdateState() async {
    state = TransferDetailsState.cameraUpdate(await _createCameraUpdate());
  }

  void _setWarningFarFromPickUpState() => state = const TransferDetailsState.warningFarFromPickUp();

  void _setWarningFarFromDropOffState() =>
      state = const TransferDetailsState.warningFarFromDropOff();

  void _setWarningLocationState() => state = const TransferDetailsState.warningLocation();

  void _setWarningSuccessfully() => state = const TransferDetailsState.successfully();

  /// Получить позицию камеры в зависмости от стадии задачи
  Future<CameraUpdate> _createCameraUpdate() async {
    final length = _data.markersForShow.length;
    if (length > 1) {
      return Future.value(CameraUpdate.newLatLngBounds(_calcLatLngBounds(), 100));
    } else if (length == 1) {
      return Future.value(CameraUpdate.newLatLngZoom(_currentLatLng(), 17));
    } else {
      final cp = await _location.getCurrentPosition();
      return Future.value(CameraUpdate.newLatLngZoom(LatLng(cp.latitude, cp.longitude), 17));
    }
  }

  LatLngBounds _calcLatLngBounds() {
    final points = _data.markersForShow.map((e) => e.position);
    final top = points.reduce((p, n) => p.latitude > n.latitude ? p : n).latitude;
    final bottom = points.reduce((p, n) => p.latitude < n.latitude ? p : n).latitude;
    final left = points.reduce((p, n) => p.longitude < n.longitude ? p : n).longitude;
    final right = points.reduce((p, n) => p.longitude > n.longitude ? p : n).longitude;

    return LatLngBounds(
      southwest: LatLng(bottom, left),
      northeast: LatLng(top, right),
    );
  }

  LatLng _currentLatLng() {
    final position = _data.markersForShow.first.position;

    return LatLng(position.latitude, position.longitude);
  }
}
