import 'package:flutter/material.dart';
import 'package:weatherly/src/models/weather_data.dart';

class SuggestionListItem extends StatelessWidget {
  final Location suggestion;

  const SuggestionListItem({
    super.key,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.location_on_outlined,
        color: Colors.amber,
      ),
      title: Text(suggestion.name ?? ''),
      subtitle: Text(suggestion.country ?? ''),
    );
  }
}
