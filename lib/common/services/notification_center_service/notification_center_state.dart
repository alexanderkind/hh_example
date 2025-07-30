import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_center_state.freezed.dart';

enum NotificationCenterWarningType {
  appUpdate,
  notification,
  gps,
}

@freezed
class NotificationCenterState with _$NotificationCenterState {
  const NotificationCenterState._();

  const factory NotificationCenterState({
    @Default(false) bool warningAppUpdate,
    @Default(false) bool warningNotification,
    @Default(false) bool warningGps,
  }) = _NotificationCenterState;

  List<NotificationCenterWarningType> get activeWarningTypes => [
        if (warningAppUpdate) NotificationCenterWarningType.appUpdate,
        if (warningNotification) NotificationCenterWarningType.notification,
        if (warningGps) NotificationCenterWarningType.gps,
      ];
}
