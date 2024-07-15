import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/models/weather_error.dart';

class ShowWeatherWidget extends StatelessWidget {
  const ShowWeatherWidget({
    super.key,
    this.weatherInfo,
    this.weatherError,
    this.dateStyle,
    this.temperatureStyle,
    this.conditionStyle,
    this.containerColor,
    this.padding,
    this.iconSize,
    this.borderRadius,
    this.temperatureUnit,
  });

  final WeatherlyData? weatherInfo;
  final WeatherlyError? weatherError;

  final TextStyle? dateStyle;
  final TextStyle? temperatureStyle;
  final TextStyle? conditionStyle;
  final Color? containerColor;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final BorderRadiusGeometry? borderRadius;
  final TemperatureUnit? temperatureUnit;

  @override
  Widget build(BuildContext context) {
    if (weatherError != null || weatherInfo == null) {
      return const SizedBox.shrink();
    }

    final date = _getDate();
    final temperature = _getTemperature();
    final condition = _getCondition();
    final iconUrl = _getIconUrl();

    return Container(
      height: 260,
      margin: const EdgeInsets.only(top: 16),
      width: 450,
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(6),
          color: containerColor ?? Colors.white,
          boxShadow: const [BoxShadow(blurRadius: 0.8, spreadRadius: 0.7)]),
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
                const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text(
            condition ?? 'N/A',
            style: conditionStyle ?? const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  DateTime _getDate() {
    final forecastDate = weatherInfo?.forecast?.forecastday?.first.date;
    final currentDate = weatherInfo?.current?.lastUpdated;
    return DateTime.tryParse(forecastDate ?? currentDate ?? '') ??
        DateTime.now();
  }

  String? _getTemperature() {
    final forecastTemp = temperatureUnit == TemperatureUnit.fahrenheit
        ? weatherInfo?.forecast?.forecastday?.first.day?.avgtempF
        : weatherInfo?.forecast?.forecastday?.first.day?.avgtempC;
    final currentTemp = temperatureUnit == TemperatureUnit.fahrenheit
        ? weatherInfo?.current?.tempF
        : weatherInfo?.current?.tempC;
    return (forecastTemp ?? currentTemp)?.toString();
  }

  String? _getCondition() {
    final forecastCondition =
        weatherInfo?.forecast?.forecastday?.first.day?.condition?.text;
    final currentCondition = weatherInfo?.current?.condition?.text;
    return forecastCondition ?? currentCondition;
  }

  String? _getIconUrl() {
    final forecastIcon =
        weatherInfo?.forecast?.forecastday?.first.day?.condition?.icon;
    final currentIcon = weatherInfo?.current?.condition?.icon;
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
