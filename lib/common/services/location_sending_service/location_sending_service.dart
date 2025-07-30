import 'dart:async';

import 'package:hh_example/common/config/config_service.dart';
import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/logs/logs.dart';
import 'package:hh_example/common/models/helpers/config/config_state_model.dart';
import 'package:hh_example/common/models/profile/update_location_request.dart';
import 'package:hh_example/common/models/task/tasks.dart';
import 'package:hh_example/common/models/task_status/task_statuses.dart';
import 'package:hh_example/common/providers/profile/profile_abstraction.dart';
import 'package:hh_example/common/providers/profile/profile_provider.dart';
import 'package:hh_example/common/providers/task/tasks_abstraction.dart';
import 'package:hh_example/common/providers/task/tasks_provider.dart';
import 'package:hh_example/common/services/location_sending_service/location_sending_state.dart';
import 'package:hh_example/common/services/notification_center_service/notification_center_service.dart';
import 'package:hh_example/common/services/notification_center_service/notification_center_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_sending_service.g.dart';

@riverpod
class LocationSendingService extends _$LocationSendingService {
  ITasks get _tasks => ref.read(tasksProvider);

  IProfile get _profile => ref.read(profileProvider);

  ConfigStateModel get _configModel => ref.read(configServiceProvider);

  NotificationCenterState get _notificationCenterState =>
      ref.read(notificationCenterServiceProvider);

  Logs get _logs => ref.read(loggerProvider);

  Timer? _sendLocationTimer;
  StreamSubscription<List<GroupTasksByDate>>? _tasksSubs;
  StreamSubscription<Position>? _positionSubs;

  @override
  LocationSendingState build() {
    ref.listenSelf((p, n) {
      _checkTimer(n.enabled);
    });

    ref.onDispose(() {
      _sendLocationTimer?.cancel();
      _tasksSubs?.cancel();
      _positionSubs?.cancel();
    });

    _init();

    return const LocationSendingState();
  }

  void _init() async {
    _tasksSubs = _tasks.tasksStream.listen(_checkNeedToSendLocation);
  }

  /// Проверка на отправку
  void _checkNeedToSendLocation(List<GroupTasksByDate> tasks) {
    if (tasks.isEmpty) {
      state = state.copyWith(enabled: false);
      return;
    }

    final statuses =
        tasks.map((g) => g.localTaskStatuses).fold(<LocalTaskStatus>{}, (p, v) => {...p, ...v});
    final validStatuses = {
      LocalTaskStatus.onRoute,
      LocalTaskStatus.arrived,
      LocalTaskStatus.customerOnBoard,
    };

    state = state.copyWith(enabled: statuses.any(validStatuses.contains));
  }

  /// Обновление координат
  void _updateCurrentPosition(Position position) {
    state = state.copyWith(currentPosition: position);
  }

  /// Проверка таймера по отправке локации на сервер
  Future<void> _checkTimer(bool enabled) async {
    if (enabled && _sendLocationTimer != null && _positionSubs != null) {
      return;
    }
    if (!enabled && _sendLocationTimer == null && _positionSubs == null) {
      return;
    }

    try {
      final configModel = _configModel;
      if (enabled) {
        if (_notificationCenterState.warningGps) {
          return;
        }

        _positionSubs = Geolocator.getPositionStream().listen(_updateCurrentPosition);
        final duration = Duration(seconds: configModel.refreshDriverOnMap);
        _sendLocationTimer = Timer.periodic(duration, (timer) {
          _sendLocation();
        });
      } else {
        _positionSubs?.cancel();
        _positionSubs = null;
        _sendLocationTimer?.cancel();
        _sendLocationTimer = null;
      }
    } catch (e, s) {
      _logs.e(e, e, s);
    }
  }

  /// Обновление местоположения
  Future<void> _sendLocation() async {
    try {
      final position = state.currentPosition;

      if (position == null) {
        throw 'LocationSendingService: position is empty';
      }

      await _profile.updateLocation(UpdateLocationRequest(
        lat: position.latitude,
        lng: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        speed: position.speed,
        timestamp: position.timestamp,
      ));
    } catch (e, s) {
      _logs.e(e, e, s);
    }
  }
}
