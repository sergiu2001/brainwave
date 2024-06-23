import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'auth.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:typed_data';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<AppUsageModel> appUsages = [];
  List<DailyActivityModel> dailyActivities = [];
  List<MentalHealthQuestionModel> mentalHealthQuestions = [];
  final Auth _auth = Auth();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsageStats();
      initializeDailyActivities();
      initializeMentalHealthQuestions();
    });
  }

  void getUsageStats() async {
    List<dynamic> apps = await _auth.getAppUsage();
    List<AppUsageModel> usageModels = [];

    for (var app in apps) {
      ApplicationWithIcon appIcon = await DeviceApps.getApp(app['appPackageName'], true) as ApplicationWithIcon;
      usageModels.add(AppUsageModel(
        app['appName'],
        app['appType'],
        app['appUsage'],
        appIcon.icon ?? Uint8List(0),  // Ensure appIcon is never null
      ));
    }

    setState(() => appUsages = usageModels);
  }

  void initializeDailyActivities() {
    List<String> activities = [
      'Going for a walk',
      'Reading a book',
      'Going out',
      'Working out',
      'Meditating',
      'Socializing',
      'Relaxing',
      'Working',
    ];
    
    List<DailyActivityModel> activityModels = activities.map((activity) => DailyActivityModel(activity, false)).toList();
    
    setState(() => dailyActivities = activityModels);
  }

  void initializeMentalHealthQuestions() {
    List<String> questions = [
      'How was your overall mood today?',
      'How stressed did you feel today?',
      'How well did you sleep last night?',
      'How anxious did you feel today?',
      'How happy did you feel today?',
    ];
    
    List<MentalHealthQuestionModel> questionModels = questions.map((question) => MentalHealthQuestionModel(question, 1)).toList();
    
    setState(() => mentalHealthQuestions = questionModels);
  }

  List<String> attributes = [
    'Home',
    'Work',
    'Public Place',
    'On the Go',
    'Happy',
    'Sad',
    'Anxious',
    'Stressed',
    'Calm',
    'Bored',
    'Excited',
    'Entertainment',
    'Communication',
    'Productivity',
    'Information',
    'Relaxation',
    'Habit',
    'Boredom',
    'Stress Relief',
    'Eating',
    'Exercising',
    'Commuting',
    'Working',
    'Relaxing',
    'Socializing',
    'Alone Time'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Page'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Apps Used'),
            subtitle: Text('Assign attributes to each app used.'),
          ),
          ...appUsages.map((app) {
            return Card(
              child: Column(
                children: [
                  ListTile(
                    leading: app.appIcon.isNotEmpty
                        ? Image.memory(app.appIcon)
                        : Icon(Icons.apps),
                    title: Text(app.appName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category: ${app.category}'),
                        Text('Usage Time: ${app.usageTime}'),
                        MultiSelectDialogField(
                          items: attributes
                              .map((attribute) =>
                                  MultiSelectItem<String>(attribute, attribute))
                              .toList(),
                          title: Text('Attributes'),
                          selectedColor: Colors.blue,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          buttonIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blue,
                          ),
                          buttonText: Text(
                            "Select Attributes",
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 16,
                            ),
                          ),
                          onConfirm: (results) {
                            setState(() {
                              app.attributes = results;
                            });
                          },
                          initialValue: app.attributes,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          ListTile(
            title: Text('Today\'s Activities'),
            subtitle: Text('Select activities you did today.'),
          ),
          ...dailyActivities.map((activity) {
            return CheckboxListTile(
              title: Text(activity.activity),
              value: activity.selected,
              onChanged: (bool? value) {
                setState(() {
                  activity.selected = value!;
                });
              },
            );
          }).toList(),

          ListTile(
            title: Text('Mental Health Questions'),
            subtitle: Text('Rate the following questions from 1 to 5.'),
          ),
          ...mentalHealthQuestions.map((question) {
            return ListTile(
              title: Text(question.question),
              trailing: DropdownButton<int>(
                value: question.rating,
                onChanged: (int? newValue) {
                  setState(() {
                    question.rating = newValue!;
                  });
                },
                items: List<int>.generate(5, (index) => index + 1)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class AppUsageModel {
  String appName;
  String category;
  String usageTime;
  List<String> attributes;
  Uint8List appIcon;

  AppUsageModel(this.appName, this.category, this.usageTime, this.appIcon,
      {this.attributes = const []});
}

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
