import 'dart:async';
import 'dart:io';

import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/logs/locale_logs.dart';
import 'package:hh_example/common/logs/logs.dart';
import 'package:hh_example/common/models/push/push_token_request.dart';
import 'package:hh_example/common/providers/push/push_abstraction.dart';
import 'package:hh_example/common/providers/push/push_provider.dart';
import 'package:hh_example/common/services/auth_status_service.dart';
import 'package:hh_example/common/services/notification_service/notification.dart';
import 'package:hh_example/common/services/notification_service/notification_state.dart';
import 'package:hh_example/common/utils/extensions/analytics/ref_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart' hide NotificationSettings;
import 'package:flutter/foundation.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_notifier.g.dart';

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  static void handleFreshChatNotification(Map<String, dynamic> message) async {
    if (await Freshchat.isFreshchatNotification(message)) {
      logger.i('is Freshchat notification');
      Freshchat.handlePushNotification(message);
    }
  }

  Logs get _logs => ref.read(loggerProvider);

  IPush get _pushProvider => ref.read(pushProvider);

  AuthStatus get _authStatus => ref.read(authStatusServiceProvider);

  FirebaseMessaging get _firebaseMessaging => FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenRefreshSubs;
  StreamSubscription<RemoteMessage>? _messagesSubs;

  @override
  PushNotificationState build() {
    listenSelf((previous, next) {
      if (previous?.token != next.token) {
        _exportPushToken();
      }
    });

    ref.onDispose(() {
      _tokenRefreshSubs?.cancel();
      _messagesSubs?.cancel();
    });

    initSubs();

    return const PushNotificationState();
  }

  void initSubs() {
    try {
      _tokenRefreshSubs = _firebaseMessaging.onTokenRefresh.listen((token) async {
        _updateToken(token);
      });

      _messagesSubs = FirebaseMessaging.onMessage.listen((message) {
        _logs.d('Firebase onMessage: ${message.toMap()}');

        final notification = onHandleMessage(message, analytics: ref.analytics);

        state = state.copyWith(data: notification);
      });
    } catch (e) {
      _logs.e(e);
    }
  }

  /// Обновление токена FCM
  Future<void> updateFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();

      _updateToken(token);
    } catch (e) {
      _logs.e(e);
    }
  }

  void _updateToken(String? token) {
    _logs.d('Firebase Token: $token');
    state = state.copyWith(token: token);
  }

  /// Отправка токена FCM на сервер
  void _exportPushToken() async {
    try {
      final token = state.token;
      if (token?.isNotEmpty == true && _authStatus == AuthStatus.authorized) {
        /// Отправка на сервер токена
        _pushProvider.setToken(PushTokenRequest(
          pushToken: state.token!,
          devicePlatform: switch (defaultTargetPlatform) {
            TargetPlatform.android => TypeDeviceEnum.android,
            TargetPlatform.iOS => TypeDeviceEnum.ios,
            _ => TypeDeviceEnum.unknown,
          },
        ));

        /// Передача токена фрешчату
        if (token != null && Platform.isAndroid) {
          Freshchat.setPushRegistrationToken(token);
        }
      }
    } catch (e) {
      /// При возникновении ошибки отправки сбросывается токен
      state = state.copyWith(token: null);
      _logs.e(e);
    }
  }
}
