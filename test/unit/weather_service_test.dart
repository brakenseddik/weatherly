import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/services/weather_config.dart';
import 'package:weatherly/src/services/weather_service.dart';

import 'test_helper.dart';

class MockDio extends Mock implements Dio {}

class MockWeatherlyConfig extends Mock implements WeatherlyConfig {}

void main() {
  late WeatherlyService weatherlyService;
  late MockDio mockDio;
  late MockWeatherlyConfig mockWeatherlyConfig;
  setUp(() {
    mockDio = MockDio();
    mockWeatherlyConfig = MockWeatherlyConfig();
    when(() => mockWeatherlyConfig.apiKey).thenReturn('mock_api_key');
    weatherlyService = WeatherlyService(
      dio: mockDio,
      weatherlyConfig: mockWeatherlyConfig,
    );
  });

  group('Weatherly Service tests', () {
    const double latitude = 48.8567;
    const double longitude = 2.3508;

    setUpAll(() {
      registerFallbackValue(RequestOptions(path: ''));
    });

    test('fetches current weather data successfully', () async {
      final weatherDataJson = dummyWeatherJsonResponse;
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          data: weatherDataJson,
          statusCode: HttpStatus.ok,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final res = await weatherlyService.getCurrentWeather(longitude, latitude);

      expect(res, isA<WeatherlyData?>());
    });

    test('fetches weather data for a specific date successfully', () async {
      final date = DateTime.now();
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          data: dummyWeatherJsonResponse,
          statusCode: HttpStatus.ok,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final weatherData = await weatherlyService.getWeather(
        longitude,
        latitude,
        date,
      );

      expect(weatherData, isA<WeatherlyData>());
    });
    test('fetches current weather with invalid coordinates', () async {
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.badResponse,
              error: dummyClientError));
      try {
        await weatherlyService.getCurrentWeather(0.0, 0.0);
      } catch (e) {
        expect(e, isA<ClientException>());
      }
    });
    test('fetches forecast data successfully', () async {
      const days = 5;
      when(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          data: dummyWeatherJsonResponse,
          statusCode: HttpStatus.ok,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final weatherData = await weatherlyService.getForecast(
        longitude,
        latitude,
        days,
      );

      expect(weatherData, isA<WeatherlyData>());
    });

    test('fetches weather data for a future date', () async {
      final date = DateTime.now().add(const Duration(days: 5));
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: dummyWeatherJsonResponse,
                statusCode: HttpStatus.ok,
                requestOptions: RequestOptions(path: ''),
              ));

      final weatherData =
          await weatherlyService.getWeather(longitude, latitude, date);

      expect(weatherData, isA<WeatherlyData>());
    });
    test('fetches weather forecast for maximum days', () async {
      const maxDays = 10;
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: dummyWeatherJsonResponse,
                statusCode: HttpStatus.ok,
                requestOptions: RequestOptions(path: ''),
              ));

      final weatherData = await weatherlyService.getForecast(
        longitude,
        latitude,
        maxDays,
      );

      expect(weatherData, isA<WeatherlyData>());
    });

    test('fetches location suggestions successfully', () async {
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: dummySuggestions,
                statusCode: HttpStatus.ok,
                requestOptions: RequestOptions(path: ''),
              ));

      final suggestions = await weatherlyService.fetchSuggestions('Paris');

      expect(suggestions, isA<List<Location>>());
      expect(suggestions.length, greaterThan(0));
    });
    test('fetches location suggestions with empty query', () async {
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: [],
                statusCode: HttpStatus.ok,
                requestOptions: RequestOptions(path: ''),
              ));

      final suggestions = await weatherlyService.fetchSuggestions('');
      expect(suggestions, isEmpty);
    });

    test('handles DioException properly', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        error: 'Some Dio error',
      ));

      expect(
        () async => await weatherlyService.getCurrentWeather(
          longitude,
          latitude,
        ),
        throwsA(isA<ClientException>()),
      );
    });
  });
}
