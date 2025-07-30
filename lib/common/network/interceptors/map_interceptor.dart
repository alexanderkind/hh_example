import 'package:hh_example/common/network/errors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class MapInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err is BadRequest) {
      return handler.reject(err);
    } else if (err.response == null) {
      return handler.reject(NoInternetConnection(err.requestOptions));
    }

    var statusCode = err.response?.statusCode ?? 500;

    if (statusCode >= 500 && statusCode <= 599) {
      return handler.reject(ServerInternal(err.requestOptions));
    }

    if (statusCode == 404) {
      return handler.reject(NotFound(err.requestOptions, err.response));
    }

    if (statusCode > 401 && statusCode <= 499) {
      return handler.reject(UnknownError(err.requestOptions, err.response));
    }

    super.onError(err, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) async {
    try {
      if (response.data != null) {
        if (response.data['error'] != null) {
          return handler.reject(
            BadRequest(
              key: response.data['error'] as String? ?? '',
              desc: response.data['message'],
              requestOptions: response.requestOptions,
            ),
          );
        }
      }
    } catch (_) {}
    if (response.data is String || response.data is Uint8List) {
      return handler.resolve(
        Response<dynamic>(
          requestOptions: response.requestOptions,
          data: response.data,
          extra: response.extra,
          redirects: response.redirects,
          statusMessage: response.statusMessage,
          statusCode: response.statusCode,
          isRedirect: response.isRedirect,
          headers: response.headers,
        ),
      );
    }
    if (response.data is Map && (response.data as Map).containsKey('response')) {
      return handler.resolve(
        Response<dynamic>(
          requestOptions: response.requestOptions,
          data: response.data?['response'],
          extra: response.extra,
          redirects: response.redirects,
          statusMessage: response.statusMessage,
          statusCode: response.statusCode,
          isRedirect: response.isRedirect,
          headers: response.headers,
        ),
      );
    }
    if (response.data is Map &&
        (response.data as Map).containsKey('data') &&
        (response.data as Map).containsKey('pagination')) {
      return handler.resolve(
        Response<Map<String, dynamic>>(
          requestOptions: response.requestOptions,
          data: {
            'data': response.data?['data'],
            'pagination': response.data?['pagination'],
          },
          extra: response.extra,
          redirects: response.redirects,
          statusMessage: response.statusMessage,
          statusCode: response.statusCode,
          isRedirect: response.isRedirect,
          headers: response.headers,
        ),
      );
    }
    if (response.data is Map && (response.data as Map).containsKey('data')) {
      return handler.resolve(
        Response<dynamic>(
          requestOptions: response.requestOptions,
          data: response.data?['data'],
          extra: response.extra,
          redirects: response.redirects,
          statusMessage: response.statusMessage,
          statusCode: response.statusCode,
          isRedirect: response.isRedirect,
          headers: response.headers,
        ),
      );
    }
    if (response.data is List) {
      return handler.resolve(
        Response<List<dynamic>>(
          requestOptions: response.requestOptions,
          data: response.data as List<dynamic>,
          extra: response.extra,
          redirects: response.redirects,
          statusMessage: response.statusMessage,
          statusCode: response.statusCode,
          isRedirect: response.isRedirect,
          headers: response.headers,
        ),
      );
    }
    return handler.resolve(
      Response<Map<String, dynamic>>(
        requestOptions: response.requestOptions,
        data: response.data as Map<String, dynamic>,
        extra: response.extra,
        redirects: response.redirects,
        statusMessage: response.statusMessage,
        statusCode: response.statusCode,
        isRedirect: response.isRedirect,
        headers: response.headers,
      ),
    );
  }
}
