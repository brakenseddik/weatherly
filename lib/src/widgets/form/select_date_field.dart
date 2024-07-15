import 'package:flutter/material.dart';

class WeatherDatePickerField extends StatelessWidget {
  const WeatherDatePickerField({
    super.key,
    required TextEditingController dateController,
    this.onDateTapped,
    this.dateInputDecoration,
  }) : _dateController = dateController;

  final TextEditingController _dateController;
  final void Function()? onDateTapped;
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
