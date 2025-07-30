import 'package:dio/dio.dart';

class NetworkException extends DioException {
  NetworkException({required super.requestOptions, super.response});
}

class BadRequest extends NetworkException {
  String key;
  dynamic desc;

  BadRequest({
    required this.key,
    required this.desc,
    required super.requestOptions,
  });
}

class NotFound extends NetworkException {
  NotFound(RequestOptions requestOptions, Response<dynamic>? response)
      : super(requestOptions: requestOptions, response: response);
}

class ServerInternal extends NetworkException {
  ServerInternal(RequestOptions requestOptions) : super(requestOptions: requestOptions);
}

class NoInternetConnection extends NetworkException {
  NoInternetConnection(RequestOptions requestOptions) : super(requestOptions: requestOptions);
}

class UnknownError extends NetworkException {
  UnknownError(RequestOptions requestOptions, Response<dynamic>? response)
      : super(requestOptions: requestOptions, response: response);
}
