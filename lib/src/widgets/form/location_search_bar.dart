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
    this.searchTileLeading,
  });

  /// Callback function invoked when a location suggestion is selected.
  final Function(Location suggestion)? onLocationSelected;

  /// Callback function invoked when the location input changes.
  final Function(String?)? onLocationChanged;

  /// Asynchronous callback to fetch location suggestions based on user input.
  final Future<List<Location>> Function(String) suggestionsCallback;

  /// Controller for managing the text input and state of the location field.
  final TextEditingController locationController;

  /// Decoration configuration for the search input field.
  final InputDecoration? searchFieldInputDecoration;

  /// Leading widget displayed in each suggestion tile within the search results.
  final Widget? searchTileLeading;

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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
        );
      },
      suggestionsCallback: suggestionsCallback,
      itemBuilder: (context, Location suggestion) {
        return SuggestionListItem(
          suggestion: suggestion,
          leading: searchTileLeading,
        );
      },
      onSelected: onLocationSelected,
    );
  }
}
