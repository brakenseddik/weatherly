import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/utils.dart';
import 'package:weatherly/src/services/weather_provider.dart';
import 'package:weatherly/src/widgets/weather_card.dart';
import 'package:weatherly/src/models/weather_error.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/widgets/weather_search_form.dart';
import 'package:weatherly/src/services/weather_service.dart';

/// A widget that displays weather details, including a search form for
/// location and date, and a card to show weather information.
///
/// The widget uses the [WeatherState] to manage its state and interacts
/// with the [WeatherlyService] to fetch weather data. It also provides
/// various customization options through its properties.
///
/// ```dart
/// WeatherlyDetailsWidget(
///   searchFieldInputDecoration: InputDecoration(
///     hintText: 'Search location',
///   ),
///   dateInputDecoration: InputDecoration(
///     hintText: 'Select date',
///   ),
///   submitButtonStyle: ButtonStyle(
///     backgroundColor: MaterialStateProperty.all(Colors.blue),
///   ),
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
///   submitButtonChild: Text('Submit'),
///   searchTileLeading: Icon(Icons.search),
///   onError: (WeatherlyError error) {
///     print('Error: ${error.message}');
///   },
/// )
/// ```
///
/// {@tool snippet}
/// This example shows how to create a [WeatherlyDetailsWidget] with
/// customized styles and a callback for handling errors:
///
/// ```dart
/// WeatherlyDetailsWidget(
///   searchFieldInputDecoration: InputDecoration(
///     hintText: 'Enter a city',
///     border: OutlineInputBorder(),
///   ),
///   dateInputDecoration: InputDecoration(
///     hintText: 'Pick a date',
///     border: OutlineInputBorder(),
///   ),
///   submitButtonStyle: ButtonStyle(
///     backgroundColor: MaterialStateProperty.all(Colors.blue),
///   ),
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
///   containerColor: Colors.lightBlueAccent,
///   padding: EdgeInsets.all(16),
///   iconSize: 48,
///   borderRadius: BorderRadius.circular(8),
///   submitButtonChild: Text('Check Weather'),
///   searchTileLeading: Icon(Icons.search),
///   onError: (WeatherlyError error) {
///     // Handle error
///     print('Error: ${error.message}');
///   },
/// )
/// ```
/// {@end-tool}
///
/// See also:
/// * [WeatherlyService], which provides weather data.
/// * [ShowWeatherWidget], which displays the weather information.
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
      create: (_) => WeatherProvider(WeatherlyService()),
      child: Consumer<WeatherProvider>(builder: (context, provider, widget) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.weatherError != null) {
            onError ?? Utils.showError(context, provider.weatherError!);
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
                      final pickedDate =
                          await Utils.showDatePickerDialog(context);
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
                  provider.weatherError == null &&
                          provider.weatherlyData != null
                      ? ShowWeatherWidget(
                          weatherlyData: provider.weatherlyData,
                          dateStyle: dateStyle,
                          temperatureStyle: temperatureStyle,
                          conditionStyle: conditionStyle,
                          containerColor: containerColor,
                          padding: padding,
                          iconSize: iconSize,
                          borderRadius: borderRadius,
                          temperatureUnit: provider.selectedUnit,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
