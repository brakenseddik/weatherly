import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/services/utils.dart';
import 'package:weatherly/src/services/weather_state.dart';
import 'package:weatherly/src/widgets/weather_card.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/widgets/weather_search_form.dart';
import 'package:weatherly/src/services/weather_service.dart';

class WeatherlyDetailsWidget extends StatelessWidget {
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

  /// Defines the button style for the submit button
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

  /// A function to be executed when something wrong e.g no internet while fetching weather details
  final Function(WeatherlyError)? onError;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherState(WeatherlyService()),
      child: Consumer<WeatherState>(builder: (context, provider, widget) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.weatherError != null) {
            onError ?? displayError(context, provider.weatherError);
            provider.clearError();
          }
        });

        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WeatherSearchForm(
                    formKey: provider.formKey,
                    locationController: provider.locationController,
                    dateController: provider.dateController,
                    searchTileLeading: searchTileLeading,
                    submitButtonStyle: submitButtonStyle,
                    onLocationSelected: (Location suggestion) =>
                        provider.seSuggestedLocation(suggestion),
                    suggestionsCallback: (String pattern) async =>
                        provider.fetchSuggestions(pattern),
                    onDateTapped: () async {
                      final pickedDate = await showDatePickerDialog(context);
                      if (pickedDate != null) {
                        provider.setSelectedDate(pickedDate);
                      }
                    },
                    onUnitChanged: (TemperatureUnit? unit) =>
                        provider.seTemperatureUnit(unit!),
                    onSubmit: (provider.selectedLocation == null)
                        ? null
                        : () {
                            provider.getWeather(
                              provider.selectedLocation!,
                              provider.selectedDate ?? DateTime.now(),
                            );
                          },
                  ),
                  ShowWeatherWidget(
                    weatherInfo: provider.weatherlyData,
                    weatherError: provider.weatherError,
                    dateStyle: dateStyle,
                    temperatureStyle: temperatureStyle,
                    conditionStyle: conditionStyle,
                    containerColor: containerColor,
                    padding: padding,
                    iconSize: iconSize,
                    borderRadius: borderRadius,
                    temperatureUnit: provider.selectedUnit,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  displayError(
    BuildContext context,
    WeatherlyError? weatherError,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(weatherError?.message ?? 'Something went wrong!!')));
  }
}
