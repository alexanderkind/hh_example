import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as pr;

import 'logs.dart';

final logger = LocaleLogs.logger();

class LocaleLogs implements Logs {
  final pr.Level level;

  LocaleLogs({
    required this.level,
  });

  factory LocaleLogs.logger() => LocaleLogs(
        level: kDebugMode ? pr.Level.all : pr.Level.off,
      );

  late final _logger = pr.Logger(
    printer: pr.PrettyPrinter(
      methodCount: 2,
      colors: Platform.isIOS != true,
      errorMethodCount: 10,
    ),
    level: level,
  );

  @override
  Future<void> d(message, [error, StackTrace? stackTrace]) async {
    return _logger.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> e(message, [error, StackTrace? stackTrace]) async {
    return _logger.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> i(message, [error, StackTrace? stackTrace]) async {
    return _logger.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> t(message, [error, StackTrace? stackTrace]) async {
    return _logger.t(message, error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> w(message, [error, StackTrace? stackTrace]) async {
    return _logger.w(message, error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> f(message, [error, StackTrace? stackTrace]) async {
    return _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
