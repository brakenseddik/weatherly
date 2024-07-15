import 'package:flutter/material.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  WeatherlyData? weatherInfo;
  WeatherlyError? weatherError;
  DateTime? selectedDate;
  Location? selectedLocation;
  TemperatureUnit? selectedUnit;
  final GlobalKey<FormState> formKey = GlobalKey();

  void setLocation(Location? location) {
    selectedLocation = location;
    notifyListeners();
  }

  void setDate(DateTime? date) {
    selectedDate = date;
    dateController.text = date.toString();
    notifyListeners();
  }

  void setUnit(TemperatureUnit? unit) {
    selectedUnit = unit;
    notifyListeners();
  }

  void setWeatherInfo(WeatherlyData? info) {
    weatherInfo = info;
    notifyListeners();
  }

  void setError(WeatherlyError? error) {
    weatherError = error;
    notifyListeners();
  }

  Future<void> getWeather(Location location, DateTime date) async {
    try {
      final res = await WeatherlyService().getWeather(
        location.lon!,
        location.lat!,
        date,
      );
      setWeatherInfo(res);
    } catch (e) {
      setError(WeatherlyError.getError(e));
    }
  }

  Future<List<Location>> fetchSuggestions(String pattern) async {
    if (pattern.isNotEmpty) {
      try {
        return await WeatherlyService().fetchSuggestions(pattern);
      } catch (e) {
        setError(WeatherlyError.getError(e));
        return [];
      }
    }
    return [];
  }
}
