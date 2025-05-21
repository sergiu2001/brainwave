import 'package:app_usage/app_usage.dart';
import 'package:installed_apps/index.dart';
import '../models/app_user_usage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUserUsageService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<List<AppUserUsage>> getAppUsage() async {
    if (_firebaseAuth.currentUser == null) return [];
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('getAppUsage');
      final result = await callable.call({
        'uid': _firebaseAuth.currentUser!.uid,
      });
      final rawList = result.data as List<dynamic>;
      return rawList.map((item) {
        final mapItem = Map<String, dynamic>.from(item as Map);
        return AppUserUsage.fromMap(mapItem);
      }).toList();
    } on FirebaseFunctionsException catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> sendAppUsage(List<AppUsageInfo> infos) async {
    if (_firebaseAuth.currentUser == null) return;
    try {
      final List<List<String>> appList = [];
      for (var info in infos) {
        final app = await InstalledApps.getAppInfo(info.packageName, BuiltWith.native_or_others) as AppInfo;
        final appName = app.name;
        final appPackageName = app.packageName;
        final appUsage = info.usage.toString();
        final appDate = info.startDate.toString().split(' ')[0];
        appList.add([appName, appPackageName, appUsage, appDate]);
      }
      final callable = FirebaseFunctions.instance.httpsCallable('sendAppUsage');
      await callable.call({
        'uid': _firebaseAuth.currentUser!.uid,
        'appList': appList,
      });
    } on FirebaseFunctionsException catch (e) {
      print(e);
    }
  }
}
