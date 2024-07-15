import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/services/weather_config.dart';

/// A service class that provides weather-related functionalities.
///
/// The `WeatherlyService` class is responsible for interacting with an external
/// weather API to fetch weather data, location suggestions.
/// This class abstracts the API calls and provides methods for
/// retrieving weather details and location suggestions based on user input.
///
/// Example usage:
/// ```dart
/// WeatherlyService weatherService = WeatherlyService();
///
/// // Fetch weather information
/// WeatherlyData weatherData = await weatherService.getWeather(lon, lat, date);
///
/// // Fetch location suggestions
/// List<Location> suggestions = await weatherService.fetchSuggestions(query);
/// ```
class WeatherlyService {
  ///[Dio] handles http requests with the weather api endpoint
  late Dio _dio;

  /// An api key is essential to interact with the weather api
  late String _apiKey;
  WeatherlyService({Dio? dio, WeatherlyConfig? weatherlyConfig}) {
    _dio = dio ??
        Dio(BaseOptions(
            baseUrl: 'http://api.weatherapi.com/v1',
            connectTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 5)));
    _apiKey = weatherlyConfig?.apiKey ?? WeatherlyConfig().apiKey;
  }

  /// Fetches the current weather data based on a geographical location (coordinates).
  ///
  /// [location] represents the latitude and longitude of a given location
  Future<WeatherlyData?> getCurrentWeather(double long, double lat) async {
    try {
      final response = await _dio.get(
        '/current.json',
        queryParameters: {
          'key': _apiKey,
          'q': '$lat,$long',
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        return WeatherlyData.fromJson(response.data);
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
  /// [location] isa  geo coordinates (latitude and longitude as String).
  /// [date] is the date for which the weather data is requested.
  /// It can be for [current], [historical] or [future] forecast.
  Future<WeatherlyData?> getWeather(
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
        return WeatherlyData.fromJson(response.data);
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
  /// [location] ia s geo coordinates (latitude and longitude as String).
  /// [days] is the number of days for which the forecast is requested (max: 10).
  Future<WeatherlyData?> getForecast(double long, double lat, int days) async {
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
        return WeatherlyData.fromJson(response.data);
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
