import 'package:flutter/material.dart';
import 'package:weatherly/src/models/weather_data.dart';

class SuggestionListItem extends StatelessWidget {
  final Location suggestion;
  final Widget? leading;

  const SuggestionListItem({
    super.key,
    required this.suggestion,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ??
          const Icon(
            Icons.location_on_outlined,
            color: Colors.amber,
          ),
      title: Text(suggestion.name ?? ''),
      subtitle: Text(suggestion.country ?? ''),
    );
  }
}
