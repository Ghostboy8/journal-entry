import 'package:flutter/material.dart';

class MoodFilter extends StatelessWidget {
  final String selectedMood;
  final Function(String) onMoodSelected;

  MoodFilter({required this.selectedMood, required this.onMoodSelected});

  final List<String> _moods = ['All', 'Happy', 'Sad', 'Neutral', 'Excited', 'Angry'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _moods.map((mood) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: FilterChip(
            label: Text(mood),
            selected: selectedMood == mood,
            onSelected: (_) => onMoodSelected(mood),
            selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        )).toList(),
      ),
    );
  }
}