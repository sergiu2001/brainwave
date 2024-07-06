import 'package:brainwave/background.dart';
import 'package:brainwave/welcome_page.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'auth.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'main.dart';

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
  late Interpreter _interpreter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsageStats();
      initializeDailyActivities();
      initializeMentalHealthQuestions();
    });
  }

  Future<void> sendReport(List<double> predictions) async {
    try {
      List<Map<String, dynamic>> appsData = appUsages.map((app) {
        return {
          'appName': app.appName,
          'appPackageName': app.appPackageName,
          'appType': app.appType,
          'appUsage': _parseAppUsage(app.appUsage),
          'attributes': app.attributes
        };
      }).toList();

      List<String> activitiesData = dailyActivities
          .where((activity) => activity.selected)
          .map((activity) => activity.activity)
          .toList();

      Map<String, int> mentalHealthData = {};
      for (var question in mentalHealthQuestions) {
        mentalHealthData[question.question] = question.rating;
      }

      await _auth.sendReport(
          appsData, activitiesData, mentalHealthData, predictions);
    } catch (e) {
      print('Error sending report: $e');
    }
  }

  void MLDownload() async {
    await FirebaseModelDownloader.instance
        .getModel(
            "BrainHealth",
            FirebaseModelDownloadType.localModel,
            FirebaseModelDownloadConditions(
              androidChargingRequired: false,
              androidWifiRequired: false,
              androidDeviceIdleRequired: false,
            ))
        .then((customModel) {
      final localModelPath = customModel.file;
      _interpreter = Interpreter.fromFile(localModelPath);
      _formatData();
    });
  }

  String formatDuration(String duration) {
    final parts = duration.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2].split('.')[0]);

    final List<String> formattedParts = [];
    if (hours > 0) {
      formattedParts.add('$hours h');
    }
    if (minutes > 0) {
      formattedParts.add('$minutes min');
    }
    if (seconds > 0 || formattedParts.isEmpty) {
      formattedParts.add('$seconds sec');
    }

    return formattedParts.join(' ');
  }

  Future<void> getUsageStats() async {
      setState(() {
        _isLoading = true;
      });

      List<dynamic> apps = await _auth.getAppUsage();
      List<AppUsageModel> usageModels = [];
      DateTime now = DateTime.now();

      List<dynamic> recentApps = apps.where((app) {
        DateTime appDate = DateTime.parse(app['appDate']);
        return now.difference(appDate).inHours <= 64;
      }).toList();

      recentApps.sort((a, b) => Duration(
              hours: int.parse(b['appUsage'].split(':')[0]),
              minutes: int.parse(b['appUsage'].split(':')[1]),
              seconds: int.parse(b['appUsage'].split(':')[2].split('.')[0]))
          .compareTo(Duration(
              hours: int.parse(a['appUsage'].split(':')[0]),
              minutes: int.parse(a['appUsage'].split(':')[1]),
              seconds: int.parse(a['appUsage'].split(':')[2].split('.')[0]))));

      for (var app in recentApps.take(20)) {
        ApplicationWithIcon appIcon =
            await DeviceApps.getApp(app['appPackageName'], true)
                as ApplicationWithIcon;
        usageModels.add(AppUsageModel(
          app['appPackageName'],
          app['appName'],
          app['appType'],
          app['appUsage'],
          appIcon.icon ?? Uint8List(0),
        ));
      }

      setState(() {
        appUsages = usageModels;
        _isLoading = false;
      });
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

    List<DailyActivityModel> activityModels = activities
        .map((activity) => DailyActivityModel(activity, false))
        .toList();

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

    List<MentalHealthQuestionModel> questionModels = questions
        .map((question) => MentalHealthQuestionModel(question, 1))
        .toList();

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

  List<String> appTypes = [
    'communication',
    'social',
    'dating',
    'video players & editors',
    'productivity',
    'travel & local',
    'finance',
    'business',
    'photography',
    'medical',
    'shopping',
    'lifestyle',
    'tools',
    'health & fitness',
    'maps & navigation',
    'food & drink',
    'weather',
    'music & audio',
    'news & magazines',
    'house & home',
    'sports',
    'personalization',
    'arcade',
    'casino',
    'puzzle',
    'simulation',
    'trivia',
    'action',
    'racing',
    'adventure',
    'music',
    'education',
    'board',
    'casual',
    'word',
    'books & reference',
    'strategy',
    'card',
    'auto & vehicles',
    'art & design',
    'events',
    'educational',
    'libraries & demo',
    'parenting',
    'beauty',
    'role playing',
    'comics',
    'NA',
    'no info',
    'not found in databases',
    'game',
    'undefined',
  ];

  double _parseAppUsage(String appUsage) {
    final parts = appUsage.split(':');
    final hours = double.parse(parts[0]);
    final minutes = double.parse(parts[1]);
    final seconds = double.parse(parts[2]);
    return hours + (minutes / 60) + (seconds / 3600);
  }

  void _formatData() {
    final List<Map<String, dynamic>> appsData = appUsages.map((app) {
      return {
        'appPackageName': app.appPackageName,
        'appType': app.appType,
        'appUsage': _parseAppUsage(app.appUsage),
        'attributes': app.attributes
      };
    }).toList();

    final List<String> activitiesData = dailyActivities
        .where((activity) => activity.selected)
        .map((activity) => activity.activity)
        .toList();

    final Map<String, int> mentalHealthData = {};
    for (var question in mentalHealthQuestions) {
      mentalHealthData[question.question] = question.rating;
    }

    final preprocessedData =
        preprocessData(appsData, activitiesData, mentalHealthData);
    _runModel(preprocessedData);
  }

  List<double> preprocessData(List<Map<String, dynamic>> apps,
      List<String> activities, Map<String, int> mentalHealth) {
    List<String> appAttributes = [
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
    List<String> dailyActivities = [
      'Going for a walk',
      'Reading a book',
      'Going out',
      'Working out',
      'Meditating',
      'Socializing',
      'Relaxing',
      'Working'
    ];
    List<String> mentalHealthQuestions = [
      'How was your overall mood today?',
      'How stressed did you feel today?',
      'How well did you sleep last night?',
      'How anxious did you feel today?',
      'How happy did you feel today?'
    ];

    int maxApps = 20;
    int appFeatureLength = appTypes.length + 1 + appAttributes.length;
    List<double> features = [];

    for (var app in apps) {
      List<double> appTypeEncoded = List.filled(appTypes.length, 0.0);
      int appTypeIndex = appTypes.indexOf(app['appType']);
      if (appTypeIndex >= 0) {
        appTypeEncoded[appTypeIndex] = 1.0;
      }

      double appUsage = app['appUsage'];
      List<double> attributesEncoded = List.filled(appAttributes.length, 0.0);
      for (var attr in app['attributes']) {
        int index = appAttributes.indexOf(attr);
        if (index >= 0) {
          attributesEncoded[index] = 1.0;
        }
      }
      features.addAll([...appTypeEncoded, appUsage, ...attributesEncoded]);
    }

    while (features.length < maxApps * appFeatureLength) {
      features.addAll(List.filled(appFeatureLength, 0.0));
    }
    if (features.length > maxApps * appFeatureLength) {
      features = features.sublist(0, maxApps * appFeatureLength);
    }

    List<double> activitiesEncoded = List.filled(dailyActivities.length, 0.0);
    for (var activity in activities) {
      int index = dailyActivities.indexOf(activity);
      if (index >= 0) {
        activitiesEncoded[index] = 1.0;
      }
    }
    features.addAll(activitiesEncoded);

    List<double> ratingsEncoded =
        List.filled(mentalHealthQuestions.length, 0.0);
    for (var question in mentalHealthQuestions) {
      int index = mentalHealthQuestions.indexOf(question);
      if (index >= 0) {
        ratingsEncoded[index] = mentalHealth[question]?.toDouble() ?? 0.0;
      }
    }
    features.addAll(ratingsEncoded);

    return features;
  }

  void _runModel(List<double> formattedData) async {
    var input = [formattedData];
    var output = List.filled(4, 0).reshape([4, 1]);
    _interpreter.run(input, output);
    print("Output: $output");
    List<double> predictions = output.map((prediction) {
      double value = prediction[0] * 100;
      value = double.parse(value.toStringAsFixed(2));
      print("Prediction: $value%");
      return value;
    }).toList();

    sendReport(predictions);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Page'),
      ),
      body: StarryBackgroundWidget(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  const ListTile(
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
                                : const Icon(Icons.apps),
                            title: Text(app.appName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category: ${app.appType}'),
                                Text(
                                    'Usage Time: ${formatDuration(app.appUsage)}'),
                                MultiSelectDialogField(
                                  items: attributes
                                      .map((attribute) =>
                                          MultiSelectItem<String>(
                                              attribute, attribute))
                                      .toList(),
                                  title: Text('Attributes',
                                      style: TextStyle(
                                          color: brainwaveTheme
                                              .colorScheme.onSurface)),
                                  selectedColor:
                                      brainwaveTheme.colorScheme.primary,
                                  backgroundColor:
                                      const Color.fromARGB(235, 58, 58, 91),
                                  itemsTextStyle: TextStyle(
                                      color:
                                          brainwaveTheme.colorScheme.onSurface),
                                  selectedItemsTextStyle: TextStyle(
                                      color:
                                          brainwaveTheme.colorScheme.onPrimary),
                                  decoration: BoxDecoration(
                                    color: brainwaveTheme.colorScheme.primary
                                        .withOpacity(0.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                      color: brainwaveTheme.colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                  buttonIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: brainwaveTheme.colorScheme.primary,
                                  ),
                                  buttonText: Text(
                                    "Select Attributes",
                                    style: TextStyle(
                                      color: brainwaveTheme.colorScheme.primary,
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
                  const ListTile(
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
                  const ListTile(
                    title: Text('Mental Health Questions'),
                    subtitle: Text('Rate the following questions from 1 to 5.'),
                  ),
                  ...mentalHealthQuestions.map((question) {
                    return ListTile(
                      title: Text(question.question),
                      trailing: DropdownButton<int>(
                        dropdownColor: const Color.fromARGB(235, 58, 58, 91),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      MLDownload();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomePage()));
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
      ),
    );
  }
}

class AppUsageModel {
  String appPackageName;
  String appName;
  String appType;
  String appUsage;
  List<String> attributes;
  Uint8List appIcon;

  AppUsageModel(this.appPackageName, this.appName, this.appType, this.appUsage,
      this.appIcon,
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
