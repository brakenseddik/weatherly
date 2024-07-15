import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weatherly/src/models/weather_data.dart';
import 'package:weatherly/src/widgets/form/suggestion_list_item.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({
    super.key,
    this.onLocationSelected,
    this.onLocationChanged,
    required this.suggestionsCallback,
    required this.locationController,
    this.searchFieldInputDecoration,
  });

  final Function(Location suggestion)? onLocationSelected;
  final Function(String?)? onLocationChanged;
  final Future<List<Location>> Function(String) suggestionsCallback;
  final TextEditingController locationController;
  final InputDecoration? searchFieldInputDecoration;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Location>(
      controller: locationController,
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onLocationChanged,
          decoration: searchFieldInputDecoration ??
              InputDecoration(
                hintText: 'Please enter a location',
                fillColor: Colors.white,
                filled: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              ),
        );
      },
      suggestionsCallback: suggestionsCallback,
      itemBuilder: (context, Location suggestion) {
        return SuggestionListItem(suggestion: suggestion);
      },
      onSelected: onLocationSelected,
    );
  }
}
