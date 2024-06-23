import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'auth.dart';

class AppUsagePage extends StatefulWidget {
  const AppUsagePage({super.key});

  @override
  State<AppUsagePage> createState() => _AppUsagePage();
}

class _AppUsagePage extends State<AppUsagePage> {
  List<dynamic> _infos = [];
  final Auth _auth = Auth();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsageStats();
    });
  }

  void getUsageStats() async {
    List<dynamic> apps = await _auth.getAppUsage();
    for (var app in apps) {
      ApplicationWithIcon appIcon = await DeviceApps.getApp(app['appPackageName'], true) as ApplicationWithIcon;
      app['appIcon'] = appIcon.icon;
    }
    setState(() => _infos = apps);
  }

  void sendAppUsage() async {
    try {
      DateTime endDate = DateTime.now().toUtc();
      DateTime startDate = endDate.subtract(Duration(
          hours: endDate.hour,
          minutes: endDate.minute,
          seconds: endDate.second,
          milliseconds: endDate.millisecond,
          microseconds: endDate.microsecond)).toUtc();
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      await _auth.sendAppUsage(infoList);
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  Future<void> refreshPage() async {
    getUsageStats();
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('App Usage'),
        ),
        body: RefreshIndicator(
            onRefresh: refreshPage,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _infos.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading:
                    Image.memory(Uint8List.fromList(_infos[index]['appIcon'])),
                title: Text(_infos[index]['appName']),
                subtitle: Text(_infos[index]['appType']),
                trailing: Text(_infos[index]['appUsage']),
              );
            },
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: sendAppUsage,
              child: const Icon(Icons.file_upload),
            ),
          ],
        ),
      );
  }
}
