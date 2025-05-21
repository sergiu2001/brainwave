import 'package:brainwave/models/app_user_usage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserReport {
  final List<AppUserUsage> apps;
  final List<String> dailyActivities;
  final Map<String, int> mentalHealthQuestions;
  final List<double> predictions;
  final String timestamp;

  const UserReport({
    required this.apps,
    required this.dailyActivities,
    required this.mentalHealthQuestions,
    required this.predictions,
    required this.timestamp,
  });

  factory UserReport.fromMap(Map<String, dynamic> map) {
    final reportMap = Map<String, dynamic>.from(map['report'] as Map);
    final responseMap = Map<String, dynamic>.from(map['response'] as Map);
    final user = UserReport(
      apps: _parseApps(reportMap['apps']),
      dailyActivities: List<String>.from(reportMap['dailyActivities']),
      mentalHealthQuestions:
          Map<String, int>.from(reportMap['mentalHealthQuestions']),
      predictions: _parsePredictions(responseMap['predictions']),
      timestamp: _parseTimestamp(reportMap['timestamp']),
    );
    return user;
  }

  static List<AppUserUsage> _parseApps(dynamic apps) {
    if (apps == null || apps is! List) return [];
    return apps.map((e) {
      final map =
          (e as Map).map((key, value) => MapEntry(key.toString(), value));
      return AppUserUsage.fromMapwithAtt(map);
    }).toList();
  }

  static List<double> _parsePredictions(dynamic predictions) {
    if (predictions == null || predictions is! List) return [];
    return predictions.map((e) => e is num ? e.toDouble() : 0.0).toList();
  }

  static String _parseTimestamp(dynamic tsData) {
    if (tsData is String) {
      return tsData;
    } else if (tsData is Map) {
      final seconds = tsData['_seconds'] as int;
      final nanoseconds = tsData['_nanoseconds'] as int;
      final ts = Timestamp(seconds, nanoseconds);
      return ts.toDate().toString();
    }
    throw Exception("Invalid timestamp format");
  }
}
