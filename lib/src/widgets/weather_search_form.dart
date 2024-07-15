import 'package:flutter/material.dart';
import 'package:weatherly/src/models/temperature_unit.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/widgets/form/location_search_bar.dart';
import 'package:weatherly/src/widgets/form/unit_dropdown_field.dart';
import 'package:weatherly/src/widgets/form/submit_button.dart';
import 'package:weatherly/src/widgets/form/select_date_field.dart';

class WeatherSearchBarWidget extends StatefulWidget {
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

  WeatherSearchBarWidget({
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
  });

  @override
  State<WeatherSearchBarWidget> createState() => _WeatherSearchBarWidgetState();
}

class _WeatherSearchBarWidgetState extends State<WeatherSearchBarWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LocationSearchBar(
              suggestionsCallback: widget.suggestionsCallback,
              locationController: widget.locationController,
              onLocationChanged: widget.onLocationChanged,
              onLocationSelected: widget.onLocationSelected,
              searchFieldInputDecoration: widget.searchFieldInputDecoration),
          SizedBox(height: widget.spaceBetweenField ?? 16.0),
          Row(
            children: [
              WeatherDatePickerField(
                dateController: widget.dateController,
                onDateTapped: widget.onDateTapped,
                dateInputDecoration: widget.dateInputDecoration,
              ),
              SizedBox(width: widget.spaceBetweenField ?? 16.0),
              UnitsDropDownField(
                onUnitChanged: widget.onUnitChanged,
                dateInputDecoration: widget.dateInputDecoration,
              ),
            ],
          ),
          SizedBox(height: widget.spaceBetweenField ?? 16.0),
          SubmitFormButton(
            onSubmit: widget.onSubmit,
            submitButtonStyle: widget.submitButtonStyle,
            submitButtonChild: widget.submitButtonChild ?? const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
