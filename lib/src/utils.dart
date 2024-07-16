import 'package:flutter/material.dart';
import 'package:weatherly/src/models/weather_error.dart';

class Utils {
  static void showError(BuildContext context, WeatherlyError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content:
            Text(error.message ?? 'Something went wrong please try later!!'),
      ),
    );
  }

  static Future<DateTime?> showDatePickerDialog(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 300)),
    );
  }
}
