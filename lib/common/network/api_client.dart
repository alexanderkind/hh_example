import 'dart:io';

import 'package:hh_example/common/config/config_service.dart';
import 'package:hh_example/common/network/interceptors/auth_interceptor.dart';
import 'package:hh_example/common/network/interceptors/map_interceptor.dart';
import 'package:hh_example/common/services/auth_status_service.dart';
import 'package:hh_example/common/services/token_holder_service.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient(
    ref.watch(configServiceProvider.notifier),
    ref.watch(tokenHolderServiceProvider),
    ref.watch(authStatusServiceProvider.notifier),
  );
}

class ApiClient {
  final ConfigService _config;

  final TokenHolderService _token;

  final AuthStatusService _authService;

  late Dio _dio;

  Dio get client => _dio;
  ConfigService get config => _config;

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        baseUrl: _config.url,
      ),
    );

    _dio.interceptors.addAll(
      [
        AuthInterceptor(
          tokenHolder: _token,
          authStatusService: _authService,
          dio: _dio,
        ),
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
          ),
          talker: Talker(
            logger: TalkerLogger(
              settings: TalkerLoggerSettings(enableColors: Platform.isIOS != true),
            ),
          ),
        ),
        MapInterceptor(),
      ],
    );
  }

  ApiClient(
    this._config,
    this._token,
    this._authService,
  ) {
    _config.addListener(_initDio);
    _initDio();
  }
}
