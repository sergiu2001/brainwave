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
  List<AppUsageInfo> _infos = [];
  final Auth _auth = Auth();

  @override
  void initState() {
    super.initState();
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(
          hours: endDate.hour,
          minutes: endDate.minute,
          seconds: endDate.second,
          milliseconds: endDate.millisecond,
          microseconds: endDate.microsecond));
      print(startDate);
      print(endDate);
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      setState(() => _infos = infoList);
      
      await _auth.sendAppUsage(infoList);

    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Usage Example'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: _infos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(_infos[index].packageName),
                  title: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                        '${_infos[index].usage.toString()} | ${_infos[index].startDate} | ${_infos[index].endDate}'),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: getUsageStats, child: const Icon(Icons.file_download)),
      ),
    );
  }
}
