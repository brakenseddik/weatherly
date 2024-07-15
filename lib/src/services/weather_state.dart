import 'package:flutter/material.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/services/weather_service.dart';

class WeatherState extends ChangeNotifier {
  final WeatherlyService weatherApi;
  WeatherData? weatherInfo;
  WeatherError? weatherError;
  DateTime? selectedDate;
  Location? selectedLocation;
  TemperatureUnit? selectedUnit;
  List<Location> suggestions = [];
  bool isLoading = false;

  WeatherState({required this.weatherApi});

  Future<void> fetchSuggestions(String pattern) async {
    if (pattern.isNotEmpty) {
      isLoading = true;
      notifyListeners();
      try {
        suggestions = await weatherApi.fetchSuggestions(pattern);
      } catch (e) {
        weatherError = WeatherError.getError(e);
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> getWeather(Location location, DateTime date) async {
    isLoading = true;
    notifyListeners();
    try {
      weatherInfo =
          await weatherApi.getWeather(location.lon!, location.lat!, date);
      weatherError = null;
    } catch (e) {
      weatherError = WeatherError.getError(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSelectedLocation(Location? location) {
    selectedLocation = location;
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void updateSelectedUnit(TemperatureUnit unit) {
    selectedUnit = unit;
    notifyListeners();
  }

  void clearWeatherData() {
    weatherInfo = null;
    weatherError = null;
    notifyListeners();
  }
}
