import 'dart:typed_data';
import 'package:brainwave/models/app_user_usage.dart';

class DailyActivityModel {
  String activity;
  bool selected;
  DailyActivityModel(this.activity, this.selected);
}

class MentalHealthQuestionModel {
  String question;
  int rating;
  MentalHealthQuestionModel(this.question, this.rating);
}

class AppUsageWithIcon {
  final AppUserUsage appModel;
  final Uint8List? iconBytes;
  final List<String> attributes;

  AppUsageWithIcon({
    required this.appModel,
    this.iconBytes,
    required this.attributes,
  });
}