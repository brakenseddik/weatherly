/// Enum representing the units of temperature in metric and imperial systems.
///
/// The [TemperatureUnit] enum provides two values:
/// - [celsius] for Celsius unit.
/// - [fahrenheit] for Fahrenheit unit.
///
/// ```dart
/// final TemperatureUnit unit = TemperatureUnit.celsius;
///
enum TemperatureUnit {
  celsius,
  fahrenheit,
}

/// Extension on [TemperatureUnit] to provide display names.
///
/// This extension adds a method [displayName] to the [TemperatureUnit] enum,
/// which returns a human-readable name for the temperature unit.
///
/// ```dart
/// TemperatureUnit unit = TemperatureUnit.celsius;
/// print('The display name is: ${unit.displayName}');
///// Output: The display name is: Celsius (°C)
/// ```
///
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
