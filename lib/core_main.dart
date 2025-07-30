import 'dart:async';
import 'dart:io';

import 'package:hh_example/common/constants/app_constants.dart';
import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/logs/locale_logs.dart';
import 'package:hh_example/common/services/notification_service/notification.dart';
import 'package:hh_example/common/themes/border_radius_sheme.dart';
import 'package:hh_example/common/themes/color_scheme.dart';
import 'package:hh_example/common/themes/text_themes.dart';
import 'package:hh_example/common/utils/firebase/firebase.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/env.dart';
import 'package:hh_example/l10n/app_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'common/router/router.dart';

void coreMain() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await firebaseInitializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      runApp(
        ProviderScope(
          overrides: await getOverridesDependency(),
          observers: [LoggerObserver()],
          child: const App(),
        ),
      );
    },
    (Object error, StackTrace stack) {
      logger.e(error, error, stack);
    },
  );
}

class LoggerObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (BuildEnvironment.isDevelopment) {
      logger.i('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
    }
  }
}

class App extends StatefulHookConsumerWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );
    });
    FlutterError.onError = (error) {
      logger.e(
        error.exception,
        error.exception,
        error.stack,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final router = ref.watch(routerProvider);

    var shortestSide = MediaQuery.of(context).size.width;
    var useMobileLayout = shortestSide < 600;
    var useTabletLandscapeLayout = shortestSide < 1100;

    return ScreenUtilInit(
      designSize: Platform.isAndroid || Platform.isIOS
          ? (useMobileLayout
              ? const Size(375, 812)
              : (useTabletLandscapeLayout ? const Size(768, 1024) : const Size(1024, 768)))
          : const Size(1440, 1134),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: MaterialApp.router(
            title: AppConstants.appName,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: theme.copyWith(
              extensions: <ThemeExtension<dynamic>>[
                colorsScheme,
                textThemes,
                ChatScheme(),
                borderRadiusScheme,
              ],
              scaffoldBackgroundColor: colorsScheme.backgroundPrimary,
              appBarTheme: AppBarTheme(
                backgroundColor: colorsScheme.backgroundPrimary,
                surfaceTintColor: Colors.transparent,
                centerTitle: false,
                titleTextStyle: textThemes.hSS.copyWith(
                  color: colorsScheme.textPrimary,
                ),
              ),
              popupMenuTheme: PopupMenuThemeData(
                color: colorsScheme.backgroundPrimary,
                shape: RoundedRectangleBorder(borderRadius: borderRadiusScheme.itemL),
                shadowColor: const Color(0x26061228),
              ),
              listTileTheme: ListTileThemeData(selectedTileColor: colorsScheme.backgroundTertiary),
              textSelectionTheme: theme.textSelectionTheme.copyWith(
                cursorColor: colorsScheme.backgroundAccent.withOpacity(0.5),
                selectionColor: colorsScheme.backgroundAccent.withOpacity(0.5),
                selectionHandleColor: colorsScheme.backgroundAccent.withOpacity(0.5),
              ),
              colorScheme: ColorScheme.fromSwatch(
                accentColor: colorsScheme.textAccent,
                backgroundColor: colorsScheme.white,
                errorColor: colorsScheme.iconNegative,
              ).copyWith(
                primary: colorsScheme.textAccent,
                secondary: colorsScheme.textSecondary,
                surface: colorsScheme.backgroundPrimary,
                onSurface: colorsScheme.textPrimary,
                error: colorsScheme.iconNegative,
              ),
              bottomSheetTheme: BottomSheetThemeData(
                // TODO(alexanderkind): Новый цвет вынести
                dragHandleColor: const Color(0xFFD0D0D0),
                dragHandleSize: Size(36.w, 4.h),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadiusScheme.bottomSheet,
                ),
              ),
              splashColor: colorsScheme.backgroundAccent.withOpacity(0.25),
              highlightColor: colorsScheme.backgroundAccent.withOpacity(0.25),
            ),
            routerConfig: router,
          ),
        );
      },
    );
  }
}
