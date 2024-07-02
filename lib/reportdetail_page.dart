import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'background.dart';

class ReportDetailPage extends StatelessWidget {
  final dynamic item;

  ReportDetailPage({required this.item});

  String formatTimestamp(dynamic timestamp) {
    final seconds = timestamp['_seconds'] as int;
    final nanos = timestamp['_nanoseconds'] as int;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000 + nanos ~/ 1000000);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  String formatDuration(double hours) {
  int h = hours.floor();
  int m = ((hours - h) * 60).floor();
  int s = (((hours - h) * 60 - m) * 60).round();

  List<String> parts = [];
  if (h > 0) parts.add('${h} h');
  if (m > 0) parts.add('${m} min');
  if (s > 0) parts.add('${s} sec');

  return parts.join(', ');
}

  @override
  Widget build(BuildContext context) {
    var report = item['report'];
    var response = item['response'] != null
        ? (item['response']['predictions'].reduce((a, b) => a + b) / item['response']['predictions'].length).toStringAsFixed(2)
        : 'No Response';

    return Scaffold(
      appBar: AppBar(
        title: Text('Report details'),
      ),
      body: StarryBackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Report Timestamp: ${formatTimestamp(report['timestamp'])}'),
                SizedBox(height: 16),
                Text('Report Details:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Apps:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...report['apps'].map<Widget>((app) {
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
                              Image.memory(Uint8List.fromList(app['appIcon']), width: 40, height: 40),
                              SizedBox(width: 8),
                              Text('App Name: ${app['appName']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('Category: ${app['appType']}'),
                          Text('Usage: ${formatDuration(app['appUsage'])}'),
                          Text('Attributes: ${app['attributes'].join(', ')}'),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: 16),
                Text('Daily Activities:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(report['dailyActivities'].join(', ')),
                SizedBox(height: 16),
                Text('Mental Health:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...report['mentalHealth'].entries.map<Widget>((entry) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${entry.key}: ${entry.value}', style: TextStyle(fontSize: 14)),
                    ),
                  );
                }).toList(),
                SizedBox(height: 16),
                Text('Overall mental health estimation: $response', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}