import 'package:flutter/material.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/widgets/form/location_search_bar.dart';
import 'package:weatherly/src/widgets/form/unit_dropdown_field.dart';
import 'package:weatherly/src/widgets/form/submit_button.dart';
import 'package:weatherly/src/widgets/form/select_date_field.dart';

class WeatherSearchForm extends StatelessWidget {
  /// The widget to display as the submit button in the search form.
  final Widget? submitButtonChild;

  /// Decoration for the search input field.
  final InputDecoration? searchFieldInputDecoration;

  /// Decoration for the date input field.
  final InputDecoration? dateInputDecoration;

  /// Style for the submit button.
  final ButtonStyle? submitButtonStyle;

  /// Space between the search and date fields in the form.
  final double? spaceBetweenField;

  /// Callback function invoked when a location suggestion is selected.
  final Function(Location suggestion)? onLocationSelected;

  /// Callback function invoked when the location input changes.
  final Function(String?)? onLocationChanged;

  /// Asynchronous callback to fetch location suggestions based on user input.
  final Future<List<Location>> Function(String) suggestionsCallback;

  /// Callback function invoked when the date input field is tapped.
  final Future<void> Function()? onDateTapped;

  /// Callback function invoked when the temperature unit selection changes.
  final void Function(TemperatureUnit?)? onUnitChanged;

  /// Callback function invoked when the form is submitted.
  final void Function()? onSubmit;

  /// Controller for managing the text input in the date field.
  final TextEditingController dateController;

  /// Controller for managing the text input in the location field.
  final TextEditingController locationController;

  /// GlobalKey to identify and manage the form's state.
  final GlobalKey formKey;

  /// Leading widget displayed in each suggestion tile.
  final Widget? searchTileLeading;

  const WeatherSearchForm({
    super.key,
    required this.dateController,
    required this.locationController,
    required this.suggestionsCallback,
    this.onLocationSelected,
    this.onLocationChanged,
    this.onDateTapped,
    this.onUnitChanged,
    this.onSubmit,
    this.searchFieldInputDecoration,
    this.dateInputDecoration,
    this.submitButtonStyle,
    this.spaceBetweenField,
    this.submitButtonChild,
    required this.formKey,
    this.searchTileLeading,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          LocationSearchBar(
            suggestionsCallback: suggestionsCallback,
            locationController: locationController,
            onLocationChanged: onLocationChanged,
            onLocationSelected: onLocationSelected,
            searchFieldInputDecoration: searchFieldInputDecoration,
            searchTileLeading: searchTileLeading,
          ),
          SizedBox(height: spaceBetweenField ?? 16.0),
          Row(
            children: [
              WeatherDatePickerField(
                dateController: dateController,
                onDateTapped: onDateTapped,
                dateInputDecoration: dateInputDecoration,
              ),
              SizedBox(width: spaceBetweenField ?? 16.0),
              UnitsDropDownField(
                onUnitChanged: onUnitChanged,
                dateInputDecoration: dateInputDecoration,
              ),
            ],
          ),
          SizedBox(height: spaceBetweenField ?? 16.0),
          SubmitFormButton(
            onSubmit: onSubmit,
            submitButtonStyle: submitButtonStyle,
            submitButtonChild: submitButtonChild,
          ),
        ],
      ),
    );
  }
}
