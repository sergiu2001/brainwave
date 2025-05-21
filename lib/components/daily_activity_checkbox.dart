import 'package:brainwave/models/report_models.dart';
import 'package:flutter/material.dart';

class DailyActivityCheckbox extends StatelessWidget {
  final DailyActivityModel activity;
  final Function(bool?) onChanged;

  static const defaultActivityTitles = [
    'Going for a walk',
      'Reading a book',
      'Going out',
      'Working out',
      'Meditating',
      'Socializing',
      'Relaxing',
      'Working',
  ];

  const DailyActivityCheckbox({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(activity.activity),
      value: activity.selected,
      onChanged: onChanged,
    );
  }

  static List<DailyActivityModel> defaultActivities() {
    return defaultActivityTitles
        .map((a) => DailyActivityModel(a, false))
        .toList();
  }
}