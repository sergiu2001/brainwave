import 'package:brainwave/models/user_report.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserReportService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<List<UserReport>> getUserReports() async {
    if (_firebaseAuth.currentUser == null) return [];
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('getReport');
      final result = await callable.call({
        'uid': _firebaseAuth.currentUser!.uid,
      });
      final dataMap = result.data as Map<String, dynamic>;
      final rawList = dataMap['matchedReportsAndResponses'] as List<dynamic>;
      return rawList.map((item) {
        final mapItem = Map<String, dynamic>.from(item as Map);
        final finalmap =  UserReport.fromMap(mapItem);
        return finalmap;
      }).toList();
    } on FirebaseFunctionsException catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> sendUserReport({
    required List<Map<String, dynamic>> apps,
    required List<String> dailyActivities,
    required Map<String, int> mentalHealthQuestions,
    required List<double> predictions,
  }) async {
    if (_firebaseAuth.currentUser == null) return;
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('sendReport');
      await callable.call({
        'uid': _firebaseAuth.currentUser!.uid,
        'apps': apps,
        'dailyActivities': dailyActivities,
        'mentalHealthQuestions': mentalHealthQuestions,
        'predictions': predictions,
      });
    } on FirebaseFunctionsException catch (e) {
      print(e);
    }
  }
}
