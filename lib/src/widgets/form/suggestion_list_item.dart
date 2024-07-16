import 'package:flutter/material.dart';
import 'package:weatherly/src/models/weather_data.dart';

class SuggestionListItem extends StatelessWidget {
  const SuggestionListItem({
    super.key,
    required this.suggestion,
    this.leading,
  });

  /// Represents a location suggestion item to display it in the ListTile.
  final Location suggestion;

  /// Leading widget displayed in the suggestion list tile.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: leading ??
            const Icon(Icons.location_on_outlined, color: Colors.amber),
        title: Text(suggestion.name ?? ''),
        subtitle: Text(suggestion.country ?? ''));
  }
}
