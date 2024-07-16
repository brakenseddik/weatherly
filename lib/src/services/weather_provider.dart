import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/services/weather_config.dart';
import 'package:weatherly/src/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherProvider(this._apiService);
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  WeatherlyData? weatherlyData;
  WeatherlyError? weatherError;
  final WeatherlyService _apiService;

  DateTime? selectedDate;
  Location? selectedLocation;
  TemperatureUnit selectedUnit = WeatherlyConfig().temperatureUnit;

  setWeatherData(WeatherlyData? data) {
    weatherlyData = data;
    notifyListeners();
  }

  void clearError() {
    weatherError = null;
    notifyListeners();
  }

  setWeatherError(WeatherlyError error) {
    weatherError = error;
    notifyListeners();
  }

  seSuggestedLocation(Location? suggestion) {
    selectedLocation = suggestion;
    locationController.text = suggestion?.name ?? '';
    notifyListeners();
  }

  setSelectedDate(DateTime pickedDate) {
    dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    selectedDate = pickedDate;
    notifyListeners();
  }

  seTemperatureUnit(TemperatureUnit unit) {
    selectedUnit = unit;
    notifyListeners();
  }

  Future<List<Location>> fetchSuggestions(String pattern) async {
    if (pattern.isNotEmpty) {
      try {
        return await _apiService.fetchSuggestions(pattern);
      } catch (e) {
        setWeatherError(WeatherlyError.getError(e));
        return [];
      }
    }
    return [];
  }

  Future getWeather(Location location, DateTime date) async {
    try {
      final res = await _apiService.getWeather(
        location.lon!,
        location.lat!,
        date,
      );
      setWeatherData(res);
    } catch (e) {
      setWeatherError(WeatherlyError.getError(e));
    }
  }
}
