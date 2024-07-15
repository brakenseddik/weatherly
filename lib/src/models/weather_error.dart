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

class WeatherError {
  final num? code;
  final String? message;

  WeatherError({required this.code, required this.message});

  factory WeatherError.fromJson(Map<String, dynamic> json) {
    return WeatherError(
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

  factory WeatherError.getError(Object e) {
    if (e is ClientException) {
      return WeatherError.fromJson(e.message);
    } else if (e is ServerException) {
      return WeatherError(
          code: -1,
          message:
              'Server is unreachable or you have a poor internet connection!!');
    } else {
      return WeatherError(code: -2, message: e.toString());
    }
  }
}
