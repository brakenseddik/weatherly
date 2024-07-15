import 'package:flutter/material.dart';

Future<DateTime?> showDatePickerDialog(BuildContext context) async {
  return await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime.now().add(const Duration(days: 300)),
  );
}
