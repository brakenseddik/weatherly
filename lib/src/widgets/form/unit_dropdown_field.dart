import 'package:flutter/material.dart';
import 'package:weatherly/src/models/temperature_unit.dart';

class UnitsDropDownField extends StatelessWidget {
  const UnitsDropDownField({
    super.key,
    required this.onUnitChanged,
    this.dateInputDecoration,
  });

  /// Callback function invoked when the temperature unit dropdown changes.
  final void Function(TemperatureUnit?)? onUnitChanged;

  /// Decoration configuration for the date input field.
  final InputDecoration? dateInputDecoration;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButtonFormField<TemperatureUnit>(
        decoration: dateInputDecoration ??
            const InputDecoration(
              labelText: 'Unit',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
        items: TemperatureUnit.values
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.displayName),
                ))
            .toList(),
        onChanged: onUnitChanged,
      ),
    );
  }
}
