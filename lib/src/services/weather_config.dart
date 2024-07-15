class WeatherlyConfig {
  static final WeatherlyConfig _singleton = WeatherlyConfig._internal();

  factory WeatherlyConfig() {
    return _singleton;
  }

  WeatherlyConfig._internal();

  String? _apiKey;

  void initialize(String apiKey) {
    _apiKey = apiKey;
  }

  String get apiKey {
    if (_apiKey == null) {
      throw Exception(
          'API key has not been initialized. Call WeatherlyConfig().initialize(apiKey) in main.dart');
    }
    return _apiKey!;
  }
}
