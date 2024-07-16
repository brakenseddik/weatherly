import 'package:weatherly/src/models/temperature_unit.dart';

/// Configuration settings for the Weatherly package.
///
/// The [WeatherlyConfig] class provides a centralized place for managing
/// configuration settings used throughout the Weatherly package. These
/// settings include the default temperature unit and API key.
///
/// Example usage:
/// ```dart
/// void main() {
///   WeatherlyConfig().initialize(
///     'API_KEY',
///     tempUnit: TemperatureUnit.celsius,
///   );
///   runApp(const MyApp());
/// }
/// ```
///
class WeatherlyConfig {
  static final WeatherlyConfig _singleton = WeatherlyConfig._internal();

  factory WeatherlyConfig() {
    return _singleton;
  }

  WeatherlyConfig._internal();

  String? _apiKey;
  TemperatureUnit? _temperatureUnit;

  void initialize(String apiKey, {TemperatureUnit? tempUnit}) {
    _apiKey = apiKey;
    _temperatureUnit = tempUnit;
  }

  TemperatureUnit get temperatureUnit =>
      _temperatureUnit ?? TemperatureUnit.celsius;
  String get apiKey {
    if (_apiKey == null) {
      throw Exception(
          'API key has not been initialized. Call WeatherlyConfig().initialize(apiKey) in main.dart');
    }
    return _apiKey!;
  }
}
