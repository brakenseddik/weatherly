import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/models/weather_error.dart';

/// A widget that displays weather information based on the provided data.
///
/// The [ShowWeatherWidget] takes weather data, styles, and other
/// customization options to display weather details in a user-friendly way.
///
/// ```dart
/// ShowWeatherWidget(
///   weatherInfo: weatherInfo,
///   weatherError: weatherError,
///   dateStyle: TextStyle(
///     fontSize: 16,
///     color: Colors.black,
///   ),
///   temperatureStyle: TextStyle(
///     fontSize: 24,
///     color: Colors.red,
///   ),
///   conditionStyle: TextStyle(
///     fontSize: 20,
///     color: Colors.grey,
///   ),
///   containerColor: Colors.white,
///   padding: EdgeInsets.all(16),
///   iconSize: 48,
///   borderRadius: BorderRadius.circular(12),
/// )
/// ```
///
class ShowWeatherWidget extends StatelessWidget {
  const ShowWeatherWidget({
    super.key,
    this.weatherlyData,
    this.dateStyle,
    this.temperatureStyle,
    this.conditionStyle,
    this.containerColor,
    this.padding,
    this.iconSize,
    this.borderRadius,
    this.temperatureUnit,
    this.height,
    this.width,
  });

  /// Holds weather information data fetched from an weather service.
  final WeatherlyData? weatherlyData;

  /// Defines the text style for displaying dates in the weather details widget.
  final TextStyle? dateStyle;

  /// Defines the text style for displaying temperature in the weather details widget.
  final TextStyle? temperatureStyle;

  /// Defines the text style for displaying weather conditions in the weather details widget.
  final TextStyle? conditionStyle;

  /// Specifies the background color for the weather details container.
  final Color? containerColor;

  /// Defines the padding around the weather details widget.
  final EdgeInsetsGeometry? padding;

  /// Specifies the size of icons used in the weather details widget.
  final double? iconSize;

  /// Defines the border radius for the weather details container.
  final BorderRadiusGeometry? borderRadius;

  /// Represents the unit used for displaying temperatures (e.g., Celsius or Fahrenheit).
  final TemperatureUnit? temperatureUnit;

  /// Defines the height for the weather details widget.
  final double? height;

  /// Defines the width for the weather details widget.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final date = _getDate();
    final temperature = _getTemperature();
    final condition = _getCondition();
    final iconUrl = _getIconUrl();

    return Container(
      height: height ?? 260,
      margin: const EdgeInsets.only(top: 16),
      width: width ?? 450,
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(6),
        color: containerColor ?? Colors.white,
        boxShadow: const [BoxShadow(blurRadius: 0.8, spreadRadius: 0.7)],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('yyyy-MM-dd').format(date),
              style: dateStyle ??
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            if (iconUrl != null)
              Image.network(
                iconUrl,
                height: iconSize ?? 100,
              ),
            Text(
              temperature != null
                  ? temperatureUnit == TemperatureUnit.fahrenheit
                      ? '$temperature°F'
                      : '$temperature°C'
                  : 'N/A',
              style: temperatureStyle ??
                  const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              condition ?? 'N/A',
              style: conditionStyle ?? const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _getDate() {
    final forecastDate = weatherlyData?.forecast?.forecastday?.first.date;
    final currentDate = weatherlyData?.current?.lastUpdated;
    return DateTime.tryParse(forecastDate ?? currentDate ?? '') ??
        DateTime.now();
  }

  String? _getTemperature() {
    final forecastTemp = temperatureUnit == TemperatureUnit.fahrenheit
        ? weatherlyData?.forecast?.forecastday?.first.day?.avgtempF
        : weatherlyData?.forecast?.forecastday?.first.day?.avgtempC;
    final currentTemp = temperatureUnit == TemperatureUnit.fahrenheit
        ? weatherlyData?.current?.tempF
        : weatherlyData?.current?.tempC;
    return (forecastTemp ?? currentTemp)?.toString();
  }

  String? _getCondition() {
    final forecastCondition =
        weatherlyData?.forecast?.forecastday?.first.day?.condition?.text;
    final currentCondition = weatherlyData?.current?.condition?.text;
    return forecastCondition ?? currentCondition;
  }

  String? _getIconUrl() {
    final forecastIcon =
        weatherlyData?.forecast?.forecastday?.first.day?.condition?.icon;
    final currentIcon = weatherlyData?.current?.condition?.icon;
    final icon = forecastIcon ?? currentIcon;
    return icon != null ? 'http:$icon' : null;
  }

  String formatTemperature({
    required double? temperature,
    required TemperatureUnit temperatureUnit,
  }) {
    if (temperature == null) {
      return 'N/A';
    }

    switch (temperatureUnit) {
      case TemperatureUnit.fahrenheit:
        return '${temperature.toStringAsFixed(1)}°F';
      case TemperatureUnit.celsius:
        return '${temperature.toStringAsFixed(1)}°C';
    }
  }
}
