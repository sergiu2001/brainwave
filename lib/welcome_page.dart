import 'package:flutter/material.dart';
import 'auth.dart';
import 'background.dart';
import 'app_usage.dart';
import 'report_page.dart';
import 'reportdetail_page.dart';
import 'main.dart';
import 'package:device_apps/device_apps.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final Auth _auth = Auth();
  bool _isExpanded = false;
  List<dynamic> _reportAndResponse = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getReport();
  }

  Future<void> getReport() async {
    List<dynamic> reportAndResponse = await _auth.getReport();
    for (var item in reportAndResponse) {
      List<dynamic> apps = item['report']['apps'];
      for (var app in apps) {
        ApplicationWithIcon? appIcon = await DeviceApps.getApp(app['appPackageName'], true) as ApplicationWithIcon?;
        app['appIcon'] = appIcon?.icon;
      }
    }
    setState(() {
      _reportAndResponse = reportAndResponse;
      _isLoading = false;
    });
  }

    Future<void> refreshPage() async {
    getReport();
    await Future.delayed(const Duration(seconds: 1));
  }

  void showNotification(BuildContext context) {
    const snackBar = SnackBar(
      backgroundColor: Color(0x806A5ACD),
      content: Text(
        style: TextStyle(color: Colors.white),
        'Your request for a medical professional has been sent. Please wait for a response.',
      ),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String formatTimestamp(dynamic timestamp) {
    final seconds = timestamp['_seconds'] as int;
    final nanos = timestamp['_nanoseconds'] as int;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000 + nanos ~/ 1000000);
    return dateTime.toString();
  }

    @override
  Widget build(BuildContext context) {
    String? email = _auth.currentUser?.email ?? "No email";
    String? profileImageUrl = 'https://picsum.photos/50';

    return Scaffold(
      body: Stack(
        children: [
          StarryBackgroundWidget(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isLoading
                        ? CircularProgressIndicator()
                        : Expanded(
                            child: RefreshIndicator(
                              onRefresh: refreshPage,
                              child: ListView.builder(
                                itemCount: _reportAndResponse.length,
                                itemBuilder: (context, index) {
                                  var item = _reportAndResponse[index];
                                  var timestamp = formatTimestamp(item['report']['timestamp']);
                                  var response = item['response'] != null ? (item['response']['predictions'].reduce((a, b) => a + b) / item['response']['predictions'].length).toStringAsFixed(2) : 'No Response';
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(16.0),
                                      leading: Icon(Icons.access_time, size: 40, color: brainwaveTheme.appBarTheme.backgroundColor),
                                      title: Text(
                                        '$timestamp',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        '$response%',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ReportDetailPage(item: item),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Container(
                      color: brainwaveTheme.appBarTheme.backgroundColor, // Use theme color
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top, bottom: 10),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          CircleAvatar(
                            backgroundImage: NetworkImage(profileImageUrl),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              email,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () {
                              _auth.signOut(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: Container(),
                    secondChild: Container(
                      color: brainwaveTheme.appBarTheme.backgroundColor, // Match the AppBar color
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Profile'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AppUsagePage()),
                                );
                              },
                              child: const Text('List of apps'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 16,
            left: 32,
            child: FloatingActionButton(
              onPressed: () {
                showNotification(context);
              },
              child: const Icon(Icons.medical_information_outlined),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportPage()),
                );
              },
              child: const Icon(Icons.assignment_rounded),
            ),
          ),
        ],
      ),
    );
  }
}