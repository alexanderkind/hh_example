import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/services/auth_status_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'routes.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  final routerKey = ref.read(globalProvider);
  var authStatus = AuthStatus.unknown;

  ref.listen(
    authStatusServiceProvider,
    (_, next) async {
      authStatus = next;
      await null;
      switch (authStatus) {
        case AuthStatus.unauthorized:
          routerKey.currentContext?.go(const AuthRoute().location);
          break;

        case AuthStatus.authorized:
          routerKey.currentContext?.go(const TasksRoute().location);
          break;

        case AuthStatus.unknown:
          routerKey.currentContext?.go(const SplashRoute().location);
          break;
      }
    },
  );

  final router = GoRouter(
    navigatorKey: routerKey,
    initialLocation: const SplashRoute().location,
    debugLogDiagnostics: true,
    routes: $appRoutes,
    redirect: (BuildContext context, GoRouterState state) {
      final isSplash = state.uri.path == const SplashRoute().location;
      if (isSplash) {
        return switch (authStatus) {
          AuthStatus.unauthorized => const AuthRoute().location,
          AuthStatus.authorized => const TasksRoute().location,
          AuthStatus.unknown => null,
        };
      }

      final isLoggingIn = state.uri.path == const AuthRoute().location;
      if (isLoggingIn) {
        return authStatus == AuthStatus.authorized ? const TasksRoute().location : null;
      }

      return null;
    },
  );
  ref.onDispose(router.dispose);

  return router;
}
