// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:hh_example/common/logs/locale_logs.dart';
import 'package:hh_example/common/network/errors.dart';
import 'package:hh_example/common/services/auth_status_service.dart';
import 'package:hh_example/common/services/token_holder_service.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final TokenHolderService tokenHolder;
  final AuthStatusService authStatusService;
  final Dio dio;

  AuthInterceptor({
    required this.tokenHolder,
    required this.authStatusService,
    required this.dio,
  });

  RequestOptions? requestOptions;
  String deviceUUID = '';

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err is BadRequest) {
      throw err;
    }
    logger.e(err.message, '${err.runtimeType} ${err.requestOptions.uri}');

    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      authStatusService.unAuth();
    }

    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, handler) {
    var token = tokenHolder.accessToken;
    if (token != null && token.isNotEmpty) {
      options._setAuthenticationHeader(token);
    }

    if (options.responseType == ResponseType.json) {
      options.headers['Accept'] = 'application/json';
    }

    options._setPlatform();

    return handler.next(options);
  }
}

extension AuthRequestOptionsX on RequestOptions {
  void _setPlatform() => headers['Platform'] = Platform.isIOS ? 'ios' : 'android';

  void _setAuthenticationHeader(final String token) => headers['Authorization'] = 'Bearer $token';
}
