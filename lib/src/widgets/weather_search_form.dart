import 'package:flutter/material.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/widgets/form/location_search_bar.dart';
import 'package:weatherly/src/widgets/form/unit_dropdown_field.dart';
import 'package:weatherly/src/widgets/form/submit_button.dart';
import 'package:weatherly/src/widgets/form/select_date_field.dart';

class WeatherSearchForm extends StatelessWidget {
  final Widget? submitButtonChild;
  final InputDecoration? searchFieldInputDecoration;
  final InputDecoration? dateInputDecoration;
  final ButtonStyle? submitButtonStyle;
  final double? spaceBetweenField;
  final Function(Location suggestion)? onLocationSelected;
  final Function(String?)? onLocationChanged;
  final Future<List<Location>> Function(String) suggestionsCallback;
  final Future<void> Function()? onDateTapped;
  final void Function(TemperatureUnit?)? onUnitChanged;
  final void Function()? onSubmit;
  final TextEditingController dateController;
  final TextEditingController locationController;
  final GlobalKey formKey;
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
