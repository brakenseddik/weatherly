import 'dart:async';

import 'package:dio/dio.dart';

class ServerException implements Exception {
  final dynamic message;

  ServerException(this.message);
}

class ClientException implements Exception {
  final dynamic message;

  ClientException(this.message);
}

class UnknownException implements Exception {
  final dynamic message;

  UnknownException(this.message);
}

/// Classifies and throws custom exceptions based on DioException type.
void getDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      throw TimeoutException(error.message);
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.connectionError:
      throw ServerException('Connection Exception: ${error.message}');
    case DioExceptionType.badResponse:
      throw ClientException(error.response?.data);
    case DioExceptionType.unknown:
      throw UnknownException('Failed to get weather data: ${error.response}');
  }
}

class WeatherlyError {
  final num? code;
  final String? message;

  WeatherlyError({required this.code, required this.message});

  factory WeatherlyError.fromJson(Map<String, dynamic> json) {
    return WeatherlyError(
      code: json['error']['code'].toInt(),
      message: json['error']['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': {
        'code': code,
        'message': message,
      },
    };
  }

  @override
  String toString() {
    return 'WeatherError{code: $code, message: $message}';
  }

  factory WeatherlyError.getError(Object e) {
    if (e is ClientException) {
      return WeatherlyError.fromJson(e.message);
    } else if (e is ServerException) {
      return WeatherlyError(
          code: -1,
          message:
              'Server is unreachable or you have a poor internet connection!!');
    } else {
      return WeatherlyError(code: -2, message: e.toString());
    }
  }
}
