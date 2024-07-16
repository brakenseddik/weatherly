import 'dart:async';

import 'package:dio/dio.dart';

/// This exception get thrown when the client failed to establish a connection
/// with the server due to low or now internet, or when the service/endpoint
/// is out of reach.
class ServerException implements Exception {
  final dynamic message;

  ServerException(this.message);
}

/// This exception get thrown when the request body doesn't satisfy the API
/// endpoint requirements it is equivalent of bed responses of web server 400
class ClientException implements Exception {
  final dynamic message;

  ClientException(this.message);
}

/// Represents Other types of [Exception] that don't match [ClientException]
/// or [ServerException]
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

/// Represents an error that occurs in the Weatherly application.
///
/// The [WeatherlyError] class encapsulates error information that can occur
/// during various operations within the Weatherly application, such as network
/// requests, or other failures. This class includes a message
/// describing the error and an optional error code.
///
/// Example usage:
/// ```dart
/// try {
///   // Some operation that might fail
///    await weatherService.getWeather(-0.00, -0.707, null);
/// } catch (e) {
///   WeatherlyError error = WeatherlyError(message: e.toString());
///   print('Error occurred: ${error.message}');
/// }
/// ```
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
    return 'WeatherlyError{code: $code, message: $message}';
  }

  /// This factory constructor converts an actual exception into a
  /// [WeatherlyError] based on the passed exception and it provides a clear
  /// error object that can be easy used in the UI.
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
