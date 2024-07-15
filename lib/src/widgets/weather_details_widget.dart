import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/services/utils.dart';
import 'package:weatherly/src/widgets/weather_card.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/widgets/weather_search_form.dart';
import 'package:weatherly/src/services/weather_service.dart';

class WeatherlyDetailsWidget extends StatefulWidget {
  const WeatherlyDetailsWidget({
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
    this.onError,
    this.searchTileLeading,
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

  /// Background color for result card
  final Color? containerColor;

  /// Padding for the widget
  final EdgeInsetsGeometry? padding;

  /// icon size
  final double? iconSize;

  /// Details card border radius
  final BorderRadiusGeometry? borderRadius;

  /// Widget to show in the submit button
  final Widget? submitButtonChild;

  /// Widget to show for the leading suggestion list tile
  final Widget? searchTileLeading;

  final Function(WeatherlyError)? onError;

  @override
  State<WeatherlyDetailsWidget> createState() => _WeatherlyDetailsWidgetState();
}

class _WeatherlyDetailsWidgetState extends State<WeatherlyDetailsWidget> {
  late final TextEditingController _locationController;
  late final TextEditingController _dateController;
  final _formKey = GlobalKey<FormState>();

  WeatherlyData? weatherInfo;
  WeatherlyError? weatherError;
  late WeatherlyService _apiService;

  DateTime? _selectedDate;
  Location? _selectedLocation;
  TemperatureUnit? _selectedUnit;

  @override
  void initState() {
    super.initState();
    _apiService = WeatherlyService();
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
              WeatherSearchForm(
                  formKey: _formKey,
                  locationController: _locationController,
                  dateController: _dateController,
                  searchTileLeading: widget.searchTileLeading,
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
                    return _fetchSuggestions(pattern);
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
                            _selectedLocation!,
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

  Future<List<Location>> _fetchSuggestions(String pattern) async {
    if (pattern.isNotEmpty) {
      try {
        return await _apiService.fetchSuggestions(pattern);
      } catch (e) {
        widget.onError ?? displayError(WeatherlyError.getError(e));
        return [];
      }
    }
    return [];
  }

  Future getWeather(Location location, DateTime date) async {
    try {
      final res =
          await _apiService.getWeather(location.lon!, location.lat!, date);
      setState(() {
        weatherInfo = res;
      });
    } catch (e) {
      widget.onError ?? displayError(WeatherlyError.getError(e));
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> displayError(
      WeatherlyError? weatherError) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(weatherError?.message ?? 'Something went wrong!!')));
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.clear();
    _locationController.clear();
  }
}
