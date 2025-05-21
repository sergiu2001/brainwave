import 'package:brainwave/animations/star_background.dart';
import 'package:brainwave/models/user_report.dart';
import 'package:flutter/material.dart';
import 'package:brainwave/utils/usage_formatter.dart';

class ReportDetailScreen extends StatelessWidget {
  final UserReport report;

  const ReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final dateStr = report.timestamp;
    final responseStr = (report.predictions.isEmpty)
        ? 'No Response'
        : '${(report.predictions.reduce((a, b) => a + b) / report.predictions.length).toStringAsFixed(2)}%';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report details'),
      ),
      body: StarryBackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Report Timestamp: $dateStr'),
                const SizedBox(height: 16),
                const Text('Report Details:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                // Apps
                const Text('Apps:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...report.apps.map((app) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              (app.appIcon != null)
                                ? Image.memory(app.appIcon!, width: 48, height: 48)
                                : const Icon(Icons.apps),
                              const SizedBox(width: 8),
                              Text(
                                app.appName,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Usage: ${formatDuration(app.appUsage)}'),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Daily Activities
                const Text('Daily Activities:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(report.dailyActivities.join(', ')),
                const SizedBox(height: 16),

                // Mental Health
                const Text('Mental Health:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...report.mentalHealthQuestions.entries.map((entry) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${entry.key}: ${entry.value}',
                          style: const TextStyle(fontSize: 14)),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                Text('Overall mental health estimation: $responseStr',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
