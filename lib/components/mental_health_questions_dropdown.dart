import 'package:flutter/material.dart';
import 'package:brainwave/models/report_models.dart';

class MentalHealthQuestionDropdown extends StatelessWidget {
  final MentalHealthQuestionModel question;
  final Function(int?) onRatingChanged;

  static const defaultQuestionsTitles = [
    'How was your overall mood today?',
    'How stressed did you feel today?',
    'How well did you sleep last night?',
    'How anxious did you feel today?',
    'How happy did you feel today?',
  ];

  const MentalHealthQuestionDropdown({
    super.key,
    required this.question,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(question.question),
      trailing: DropdownButton<int>(
        value: question.rating,
        onChanged: onRatingChanged,
        items: List.generate(5, (i) => i + 1)
            .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
            .toList(),
      ),
    );
  }

  static List<MentalHealthQuestionModel> defaultQuestions() {
    return defaultQuestionsTitles
        .map((q) => MentalHealthQuestionModel(q, 1))
        .toList();
  }
}
