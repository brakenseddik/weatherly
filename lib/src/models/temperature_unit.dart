enum TemperatureUnit {
  celsius,
  fahrenheit,
}

extension TemperatureUnitExtension on TemperatureUnit {
  String get displayName {
    switch (this) {
      case TemperatureUnit.celsius:
        return 'Celsius (°C)';
      case TemperatureUnit.fahrenheit:
        return 'Fahrenheit (°F)';
    }
  }
}
