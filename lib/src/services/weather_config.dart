import 'package:weatherly/src/models/temperature_unit.dart';

/// This class represents the weather service configuration
///
/// It has one method to initialise the API key which this later is needed to perform http calls.

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
