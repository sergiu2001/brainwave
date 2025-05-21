import 'dart:typed_data';
import 'package:brainwave/animations/star_background.dart';
import 'package:brainwave/providers/app_user_usage_provider.dart';
import 'package:brainwave/providers/user_report_provider.dart';
import 'package:brainwave/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/index.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:brainwave/models/report_models.dart';
import 'package:brainwave/components/daily_activity_checkbox.dart';
import 'package:brainwave/components/app_usage_card.dart';
import 'package:brainwave/components/mental_health_questions_dropdown.dart';
import 'package:brainwave/components/attributes_choices.dart';
import 'dart:math';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<AppUsageWithIcon> _apps = [];
  final List<DailyActivityModel> _dailyActivities = DailyActivityCheckbox.defaultActivities();
  final List<MentalHealthQuestionModel> _mentalHealthQuestions = MentalHealthQuestionDropdown.defaultQuestions();

  bool _isLoading = true;
  bool _isSending = false;
  Interpreter? _interpreter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    await _fetchRecentAppUsage();
    setState(() => _isLoading = false);
  }

  Future<void> _fetchRecentAppUsage() async {
    final usageProvider = context.read<AppUserUsageProvider>();
    await usageProvider.getAppUsage();
    final usageList = usageProvider.appUsage;

    final updated = <AppUsageWithIcon>[];
    for (final app in usageList) {
      final icon = await _fetchAppIcon(app.appPackageName);
      updated.add(
        AppUsageWithIcon(appModel: app, iconBytes: icon, attributes: []),
      );
    }

    setState(() {
      _apps = updated;
    });
  }

  Future<Uint8List?> _fetchAppIcon(String packageName) async {
    final app =
        await InstalledApps.getAppInfo(packageName, BuiltWith.native_or_others) as AppInfo;
    return app.icon;
  }

  Future<void> _downloadMLModelAndPredict() async {
    setState(() => _isSending = true);

    final model = await FirebaseModelDownloader.instance.getModel(
      "BrainHealth",
      FirebaseModelDownloadType.localModel,
      FirebaseModelDownloadConditions(
        androidChargingRequired: false,
        androidWifiRequired: false,
        androidDeviceIdleRequired: false,
      ),
    );

    _interpreter = Interpreter.fromFile(model.file);
    final predictions = _runInference();
    await _sendReport(predictions);

    setState(() => _isSending = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  List<double> _runInference() {
    if (_interpreter == null) {
      return [];
    }

    // --- Input Preparation ---
    final inputFeatures = _preprocessData();
    if (inputFeatures.length != 408) {
      throw Exception(
        'Expected 408 floats, got ${inputFeatures.length}',
      );
    }
    final input = [inputFeatures]; // Shape [1, 408]

    // --- Output Buffer Preparation ---
    final output = List.generate(1, (_) => List.filled(1, 0.0));

    try {
      // Run inference
      _interpreter!.run(input, output);
    } catch (e) {
      return [];
    }

    // Extract predictions
    final predictions = List<double>.from(output[0]);
    return predictions.map((val) => val * 100).toList();
  }

  List<double> _preprocessData() {
    List<double> features = [];
    const int expectedFeatures = 408; // Update to match model expectation

    // 1. Mental Health Ratings (Normalized 0-1)
    features.addAll(
      _mentalHealthQuestions.map((q) => (q.rating - 1) / 4.0),
    );

    // 2. Daily Activities (One-Hot Encoded)
    final possibleActivities = DailyActivityCheckbox.defaultActivityTitles;
    final selectedActivities = _dailyActivities
        .where((a) => a.selected)
        .map((a) => a.activity)
        .toSet();
    features.addAll(
      possibleActivities.map((activity) => selectedActivities.contains(activity) ? 1.0 : 0.0),
    );

    // 3. App Attributes (Counts)
    final possibleAttributes = AttributesChoices.possibleAttributes;
    final attributeCounts = { for (var attr in possibleAttributes) attr : 0.0 };
    for (final appItem in _apps) {
      for (final attribute in appItem.attributes) {
        if (attributeCounts.containsKey(attribute)) {
          attributeCounts[attribute] = attributeCounts[attribute]! + 1.0;
        }
      }
    }
    features.addAll(possibleAttributes.map((attr) => attributeCounts[attr] ?? 0.0));

    // 4. Total App Usage Time (Normalized 0-1)
    double totalUsageSeconds = _apps.fold(0.0, (sum, item) => 
      sum + (item.appModel.appUsage is Duration 
        ? (item.appModel.appUsage as Duration).inSeconds 
        : 0.0));
    double normalizedUsage = totalUsageSeconds / const Duration(days: 1).inSeconds;
    features.add(min(normalizedUsage, 1.0));

    // Padding - This logic will now pad up to 408 features
    int currentFeatures = features.length;
    if (currentFeatures < expectedFeatures) {
      features.addAll(List<double>.filled(expectedFeatures - currentFeatures, 0.0));
    } else if (currentFeatures > expectedFeatures) {
      features = features.sublist(0, expectedFeatures);
    }

    if (features.length != expectedFeatures) {
      throw Exception(
        'Preprocessing Error: Expected $expectedFeatures features, but generated ${features.length}',
      );
    }

    print("Preprocessed Features (${features.length}): $features");
    return features;
  }

  Future<void> _sendReport(List<double> predictions) async {
    final reportProvider = context.read<UserReportProvider>();

    final appsData = _apps.map((a) {
      final am = a.appModel;
      return {
        'appName': am.appName,
        'appPackageName': am.appPackageName,
        'appUsage': am.appUsage,
        'attributes': a.attributes,
      };
    }).toList();

    final dailyActivities = _dailyActivities
        .where((d) => d.selected)
        .map((d) => d.activity)
        .toList();

    final mentalHealthData = <String, int>{};
    for (var q in _mentalHealthQuestions) {
      mentalHealthData[q.question] = q.rating;
    }

    await reportProvider.sendReport(
      apps: appsData,
      dailyActivities: dailyActivities,
      mentalHealthQuestions: mentalHealthData,
      predictions: predictions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Page')),
      body: StarryBackgroundWidget(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildReportContent(),
      ),
    );
  }

  Widget _buildReportContent() {
    return ListView(
      children: [
        _buildAppUsageSection(),
        _buildDailyActivitiesSection(),
        _buildMentalHealthSection(),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildAppUsageSection() {
    return Column(
      children: [
        const ListTile(
          title: Text('Apps Used'),
          subtitle: Text('Assign attributes to each app used.'),
        ),
        ..._apps.map((appItem) => AppUsageCard(
              appItem: appItem,
              onAttributeSelected: (attribute, selected) {
                setState(() {
                  if (selected) {
                    appItem.attributes.add(attribute);
                  } else {
                    appItem.attributes.remove(attribute);
                  }
                });
              },
            )),
      ],
    );
  }

  Widget _buildDailyActivitiesSection() {
    return Column(
      children: [
        const ListTile(
          title: Text('Today\'s Activities'),
          subtitle: Text('Select activities you did today.'),
        ),
        ..._dailyActivities.map(
          (activity) => DailyActivityCheckbox(
            activity: activity,
            onChanged: (val) =>
                setState(() => activity.selected = val ?? false),
          ),
        ),
      ],
    );
  }

  Widget _buildMentalHealthSection() {
    return Column(
      children: [
        const ListTile(
          title: Text('Mental Health Questions'),
          subtitle: Text('Rate from 1 to 5.'),
        ),
        ..._mentalHealthQuestions.map(
          (question) => MentalHealthQuestionDropdown(
            question: question,
            onRatingChanged: (val) =>
                setState(() => question.rating = val ?? 1),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ElevatedButton(
        onPressed: _isSending ? null : _downloadMLModelAndPredict,
        child: _isSending
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text('Submit'),
      ),
    );
  }
}
