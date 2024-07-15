import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/services/utils.dart';
import 'package:weatherly/src/widgets/weather_card.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/widgets/weather_search_form.dart';
import 'package:weatherly/src/services/weather_service.dart';

class WeatherDetailsWidget extends StatefulWidget {
  const WeatherDetailsWidget({
    super.key,
    this.searchFieldInputDecoration,
    this.dateInputDecoration,
    this.submitButtonStyle,
    this.dateStyle,
    this.temperatureStyle,
    this.conditionStyle,
    this.containerColor,
    this.padding,
    this.iconSize,
    this.borderRadius,
    this.submitButtonChild,
  });

  /// InputDecoration for the search input text field
  final InputDecoration? searchFieldInputDecoration;

  /// InputDecoration for the date input text field
  final InputDecoration? dateInputDecoration;

  /// defines the style for the submit button
  final ButtonStyle? submitButtonStyle;

  /// Datetime text style
  final TextStyle? dateStyle;

  /// Temperature text style
  final TextStyle? temperatureStyle;

  /// weather condition text style
  final TextStyle? conditionStyle;
  final Color? containerColor;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final BorderRadiusGeometry? borderRadius;
  final Widget? submitButtonChild;

  @override
  State<WeatherDetailsWidget> createState() => _WeatherDetailsWidgetState();
}

class _WeatherDetailsWidgetState extends State<WeatherDetailsWidget> {
  late final TextEditingController _locationController;
  late final TextEditingController _dateController;

  WeatherData? weatherInfo;
  WeatherError? weatherError;
  late WeatherApi _apiService;

  DateTime? _selectedDate;
  Location? _selectedLocation;
  TemperatureUnit? _selectedUnit;
  List<Location> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _apiService = WeatherApi();
    _locationController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WeatherSearchBarWidget(
                  locationController: _locationController,
                  dateController: _dateController,
                  onLocationSelected: (Location suggestion) {
                    setState(() {
                      _locationController.text = suggestion.name ?? '';
                      _selectedLocation = suggestion;
                    });
                  },
                  onLocationChanged: (String? pattern) {
                    setState(() {
                      _selectedLocation = null;
                    });
                  },
                  suggestionsCallback: (String pattern) async {
                    log('Pattern: $pattern');
                    return suggestionCallback(pattern);
                  },
                  onDateTapped: () async {
                    final pickedDate = await showDatePickerDialog(context);
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  onUnitChanged: (TemperatureUnit? unit) {
                    setState(() {
                      _selectedUnit = unit;
                    });
                  },
                  onSubmit: (_selectedLocation == null || _selectedUnit == null)
                      ? null
                      : () => getWeather(
                            _selectedLocation!.name!,
                            _selectedDate ?? DateTime.now(),
                          )),
              ShowWeatherWidget(
                weatherInfo: weatherInfo,
                weatherError: weatherError,
                dateStyle: widget.dateStyle,
                temperatureStyle: widget.temperatureStyle,
                conditionStyle: widget.conditionStyle,
                containerColor: widget.containerColor,
                padding: widget.padding,
                iconSize: widget.iconSize,
                borderRadius: widget.borderRadius,
                temperatureUnit: _selectedUnit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchSuggestions(String pattern) async {
    if (pattern.isNotEmpty) {
      try {
        final results = await _apiService.fetchSuggestions(pattern);
        setState(() {
          _suggestions = results;
        });
      } catch (e) {
        final weatherError = WeatherError.getError(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(weatherError.message ?? 'Something went wrong!!')),
        );
      }
    }
  }

  Future<List<Location>> suggestionCallback(pattern) async {
    await _fetchSuggestions(pattern);
    return _suggestions;
  }

  Future getWeather(String location, DateTime date) async {
    try {
      final res = await _apiService.getWeather(location, date);
      setState(() {
        weatherInfo = res;
      });
    } catch (e) {
      setState(() {
        weatherError = WeatherError.getError(e);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(weatherError!.message ?? 'Something went wrong!!')),
      );
    }
  }
}
