import 'package:flutter/material.dart';

class WeatherDatePickerField extends StatelessWidget {
  const WeatherDatePickerField({
    super.key,
    required TextEditingController dateController,
    this.onDateTapped,
    this.dateInputDecoration,
  }) : _dateController = dateController;

  /// Controller for managing the text input and state of the date field.
  final TextEditingController _dateController;

  /// Callback function invoked when the date input field is tapped.
  final void Function()? onDateTapped;

  /// Decoration configuration for the date input field.
  final InputDecoration? dateInputDecoration;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
          controller: _dateController,
          decoration: dateInputDecoration ??
              const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
          readOnly: true,
          onTap: onDateTapped),
    );
  }
}
