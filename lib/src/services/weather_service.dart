import 'dart:async';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/src/constants.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/services/weather_config.dart';

class WeatherApiError {}

class WeatherApi {
  late Dio _dio;
  late String _apiKey;

  WeatherApi() {
    _dio = Dio(Constants.dioOptions);
    _apiKey = WeatherlyConfig().apiKey;
  }

  /// [getWeather] method fetches and get the weather data based on a geographical location and date
  /// It accepts two parameters [String location] and [DateTime date]
  /// Based on the selected date the fetched data can rbe for current date, past days of forecasting for future.
  Future<WeatherData?> getWeather(String location, DateTime date) async {
    try {
      final String endpoint = _getEndpoint(date);
      final formatted = DateFormat('yyyy-MM-dd').format(date);
      final response = await _dio.get(
        '/$endpoint.json',
        queryParameters: {
          'key': _apiKey,
          'q': location,
          'dt': formatted,
        },
      );
      if (response.statusCode == 200) {
        return WeatherData.fromJson(response.data);
      } else {
        throw Exception('Failed to get weather data: ${response.statusCode}');
      }
    } on DioException catch (error) {
      _getDioException(error);
    } catch (error) {
      throw UnknownException('Failed to get weather data: $error');
    }
    return null;
  }

  /// This method is designed to classify the type of exception received
  /// and it throws a custom exception with message to be catched in the UI
  void _getDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(error.message);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.connectionError:
        throw ServerException('Connection Exception:${error.message}');
      case DioExceptionType.badResponse:
        throw ClientException(error.response?.data);
      case DioExceptionType.unknown:
        throw UnknownException('Failed to get weather data: ${error.response}');
    }
  }

  ///[fetchSuggestions] helps the user to fetch the weather data for the right location
  ///it takes a [String pattern] as an arg and return a list of suggestions.
  Future<List<Location>> fetchSuggestions(String? city) async {
    try {
      final response = await _dio.get(
          'http://api.weatherapi.com/v1/search.json',
          queryParameters: {'key': _apiKey, 'q': city});
      if (response.statusCode == 200) {
        List<Location> suggestions = (response.data as List)
            .map((data) => Location.fromJson(data))
            .toList();
        return suggestions;
      } else {
        return [];
      }
    } on DioException catch (error) {
      _getDioException(error);
    } catch (error) {
      throw UnknownException('Failed to get weather data: $error');
    }
    return [];
  }

  /// This method return the right api endpoint path based on the passed date
  /// it takes a [DateTime] as an argument
  /// There are three option [current], [history] and [future]
  String _getEndpoint(DateTime date) {
    final now = DateTime.now();

    if (date.isBefore(now)) {
      return 'history'; // Historical data
    } else if (date.isAfter(now.add(const Duration(days: 14)))) {
      return 'future'; // Future data
    } else {
      return 'forecast'; // Current weather + 10 days forecast
    }
  }
}
