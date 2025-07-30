import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hh_example/common/logs/locale_logs.dart';
import 'package:logger/logger.dart' as pr;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final globalNavKey = GlobalKey<NavigatorState>();
final shellNavigatorTasksKey = GlobalKey<NavigatorState>();
final shellNavigatorChatKey = GlobalKey<NavigatorState>();
final shellNavigatorProfileKey = GlobalKey<NavigatorState>();

Future<List<Override>> getOverridesDependency() async {
  await EncryptedSharedPreferences.initialize('');
  final encSharedPref = EncryptedSharedPreferences.getInstance();
  final packageInfo = await PackageInfo.fromPlatform();

  return [
    encryptedSharedPrefProvider.overrideWithValue(encSharedPref),
    packageInfoProvider.overrideWithValue(packageInfo)
  ];
}

final globalProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return globalNavKey;
});

final loggerProvider = Provider<LocaleLogs>((ref) {
  return LocaleLogs(
    level: kReleaseMode ? pr.Level.off : pr.Level.trace,
  );
});

final encryptedSharedPrefProvider = Provider<EncryptedSharedPreferences>((ref) {
  throw UnimplementedError();
});

final packageInfoProvider = Provider<PackageInfo>((ref) {
  throw UnimplementedError();
});
