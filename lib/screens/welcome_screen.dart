import 'package:brainwave/animations/star_background.dart';
import 'package:brainwave/models/app_user_usage.dart';
import 'package:brainwave/models/user_report.dart';
import 'package:brainwave/providers/auth_provider.dart';
import 'package:brainwave/providers/user_report_provider.dart';
import 'package:brainwave/screens/app_usage_screen.dart';
import 'package:brainwave/screens/login_screen.dart';
import 'package:brainwave/screens/profile_screen.dart';
import 'package:brainwave/screens/report_detail_screen.dart';
import 'package:brainwave/screens/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isExpanded = false;
  List<UserReport> _reports = [];
  bool _isIconsLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReports();
    });
  }

  Future<void> _loadReports() async {
    setState(() {
      _isIconsLoading = true;
    });
    final reportProvider = context.read<UserReportProvider>();
    await reportProvider.getUserReports();

    final reports = reportProvider.userReports;
    final newReports = <UserReport>[];

    for (final report in reports) {
      final newApp = <AppUserUsage>[];
      for (final app in report.apps) {
        AppInfo appWithIcon =
            await InstalledApps.getAppInfo(app.appPackageName, BuiltWith.native_or_others)
                as AppInfo;
        newApp.add(AppUserUsage(
          appName: app.appName,
          appPackageName: app.appPackageName,
          appUsage: app.appUsage,
          appIcon: appWithIcon.icon,
        ));
      }
      newReports.add(UserReport(
        apps: newApp,
        dailyActivities: report.dailyActivities,
        mentalHealthQuestions: report.mentalHealthQuestions,
        predictions: report.predictions,
        timestamp: report.timestamp,
      ));
    }
    setState(() {
      _reports = newReports;
      _isIconsLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    await _loadReports();
    await Future.delayed(const Duration(seconds: 800));
  }

  Future<void> _signOut() async {
    await context.read<AuthProvider>().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<UserReportProvider>();
    final authProvider = context.watch<AuthProvider>();

    final isLoading = reportProvider.isLoading || _isIconsLoading;
    final userEmail = authProvider.user?.email ?? 'No email';
    const profileImageURL = 'https://picsum.photos/200';

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
                          if (isLoading)
                            const CircularProgressIndicator()
                          else
                            Expanded(
                                child: RefreshIndicator(
                                    onRefresh: _onRefresh,
                                    child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: _reports.length,
                                        itemBuilder: (context, index) {
                                          final report = _reports[index];
                                          final timestamp = report.timestamp;
                                          String response = 'No prediction!';
                                          if (report.predictions.isNotEmpty) {
                                            final avg = report.predictions
                                                    .reduce((a, b) => a + b) /
                                                report.predictions.length;
                                            response =
                                                '${avg.toStringAsFixed(2)}%';
                                          }
                                          return Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.all(
                                                          16.0),
                                                  leading: Icon(
                                                    Icons
                                                        .insert_chart_outlined_rounded,
                                                    size: 40,
                                                    color: Theme.of(context)
                                                        .appBarTheme
                                                        .backgroundColor,
                                                  ),
                                                  title: Text(
                                                    timestamp,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    response,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  onTap: () {
                                                    // Navigate to a detail page
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ReportDetailScreen(
                                                          report: report,
                                                        ),
                                                      ),
                                                    );
                                                  }));
                                        })))
                        ],
                      )))),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => _isExpanded = !_isExpanded);
                    },
                    child: Container(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        bottom: 10,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(profileImageURL),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              userEmail,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: _signOut,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: Container(),
                    secondChild: Container(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(
                                        userProfile: profileImageURL),
                                  ),
                                );
                              },
                              child: const Text('Profile',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AppUsageScreen()),
                                );
                              },
                              child: const Text('List of apps',
                                  style: TextStyle(fontSize: 16)),
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
              heroTag: 'medical',
              onPressed: () {
                _showNotification(context);
              },
              child: const Icon(Icons.medical_information_outlined),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'report',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportScreen()),
                );
              },
              child: const Icon(Icons.assignment_rounded),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotification(BuildContext context) {
    const snackBar = SnackBar(
      backgroundColor: Color(0x806A5ACD),
      content: Text(
        'Your request for a medical professional has been sent. Please wait for a response.',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
