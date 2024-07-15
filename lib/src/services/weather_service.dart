import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/src/constants.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/services/weather_config.dart';

class WeatherlyService {
  late Dio _dio;
  late String _apiKey;

  WeatherlyService({Dio? dio, WeatherlyConfig? weatherlyConfig}) {
    _dio = dio ?? Dio(Constants.dioOptions);
    _apiKey = weatherlyConfig?.apiKey ?? WeatherlyConfig().apiKey;
  }

  /// Fetches the current weather data based on a geographical location (name or coordinates).
  ///
  /// [location] can be either a place name (String) or geo coordinates (latitude and longitude as String).
  Future<WeatherData?> getCurrentWeather(double long, double lat) async {
    try {
      final response = await _dio.get(
        '/current.json',
        queryParameters: {
          'key': _apiKey,
          'q': '$lat,$long',
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        return WeatherData.fromJson(response.data);
      }
    } on DioException catch (error) {
      getDioException(error);
    } catch (error) {
      throw UnknownException('Failed to get current weather data: $error');
    }
    return null;
  }

  /// Fetches weather data for a specific date based on a geographical location.
  ///
  /// [location] can be either a place name (String) or geo coordinates (latitude and longitude as String).
  /// [date] is the date for which the weather data is requested.
  Future<WeatherData?> getWeather(
      double long, double lat, DateTime date) async {
    try {
      final String endpoint = _getEndpoint(date);
      final formatted = DateFormat('yyyy-MM-dd').format(date);
      final response = await _dio.get(
        '/$endpoint.json',
        queryParameters: {
          'key': _apiKey,
          'q': '$lat,$long',
          'dt': formatted,
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        return WeatherData.fromJson(response.data);
      }
    } on DioException catch (error) {
      getDioException(error);
    } catch (error) {
      throw UnknownException('Failed to get weather data: $error');
    }
    return null;
  }

  /// Fetches a weather forecast for a specific number of days (up to 10) based on a geographical location.
  ///
  /// [location] can be either a place name (String) or geo coordinates (latitude and longitude as String).
  /// [days] is the number of days for which the forecast is requested (max: 10).
  Future<WeatherData?> getForecast(double long, double lat, int days) async {
    if (days > 10) {
      throw ArgumentError('Forecast can only be fetched for up to 10 days.');
    }

    try {
      final response = await _dio.get(
        '/forecast.json',
        queryParameters: {
          'key': _apiKey,
          'q': '$lat,$long',
          'days': days,
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        return WeatherData.fromJson(response.data);
      }
    } on DioException catch (error) {
      getDioException(error);
    } catch (error) {
      throw UnknownException('Failed to get forecast data: $error');
    }
    return null;
  }

  /// Fetches location suggestions based on a city name pattern.
  ///
  /// [query] is the name pattern for which suggestions are requested.
  Future<List<Location>> fetchSuggestions(String? query) async {
    try {
      final response = await _dio.get(
        'http://api.weatherapi.com/v1/search.json',
        queryParameters: {'key': _apiKey, 'q': query},
      );
      if (response.statusCode == HttpStatus.ok) {
        List<Location> suggestions = (response.data as List)
            .map((data) => Location.fromJson(data))
            .toList();
        return suggestions;
      } else {
        return [];
      }
    } on DioException catch (error) {
      getDioException(error);
    } catch (error) {
      throw UnknownException('Failed to get suggestions: $error');
    }
    return [];
  }

  /// Returns the appropriate API endpoint based on the date.
  ///
  /// [date] is the date for which the weather data is requested.
  String _getEndpoint(DateTime date) {
    final now = DateTime.now();

    if (date.isBefore(now)) {
      return 'history'; // Historical data
    } else if (date.isAfter(now.add(const Duration(days: 14)))) {
      return 'future'; // Future data
    } else {
      return 'forecast'; // Current weather + 14 days forecast
    }
  }
}
