import 'package:hh_example/common/models/helpers/notifications/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_state.freezed.dart';

@freezed
class PushNotificationState with _$PushNotificationState {
  const factory PushNotificationState({
    String? token,
    NotificationModel? data,
  }) = _PushNotificationState;
}
