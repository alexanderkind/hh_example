import 'dart:async';

import 'package:hh_example/common/models/helpers/notifications/notification_model.dart';
import 'package:hh_example/common/services/analytics/analytics_event.dart';
import 'package:hh_example/common/services/analytics/analytics_service.dart';
import 'package:hh_example/common/services/analytics/analytics_service_impl.dart';
import 'package:hh_example/common/services/notification_service/notification_notifier.dart';
import 'package:hh_example/common/utils/firebase/firebase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await firebaseInitializeApp();

  final analytics = ProviderContainer().read(analyticsServiceProvider.notifier);

  onHandleMessage(message, analytics: analytics);

  NotificationNotifier.handleFreshChatNotification(message.data);
}

/// Метод для обработки пуша
NotificationModel? onHandleMessage(
  RemoteMessage message, {
  AnalyticsServiceImpl? analytics,
}) {
  try {
    final notification = NotificationModel.fromJson(message.data);
    notification.whenOrNull(
      unknown: () {
        /// Обработка остальных пушей
      },
      taskRemainder: (pickupAt) {
        /// Отправка события в аналитику
        analytics?.logEvent(AnalyticsEvent.pushAboutPickUp(pickupAt));
      },
    );
    return notification;
  } catch (e) {
    return null;
  }
}
