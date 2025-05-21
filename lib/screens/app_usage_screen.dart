import 'package:brainwave/animations/star_background.dart';
import 'package:brainwave/models/app_user_usage.dart';
import 'package:brainwave/providers/app_user_usage_provider.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brainwave/utils/usage_formatter.dart';

class AppUsageScreen extends StatefulWidget {
  const AppUsageScreen({super.key});

  @override
  State<AppUsageScreen> createState() => _AppUsageScreenState();
}

class _AppUsageScreenState extends State<AppUsageScreen> {
  List<AppUserUsage> _appUsage = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAppUsage();
    });
  }

  Future<void> getAppUsage() async {
    setState(() {
      _isLoading = true;
    });

    final usageProvider = context.read<AppUserUsageProvider>();
    await usageProvider.getAppUsage();

    final newAppUsage = <AppUserUsage>[];
    for (final app in usageProvider.appUsage) {
      final appIcon = await InstalledApps.getAppInfo(app.appPackageName, BuiltWith.native_or_others) as AppInfo;
      newAppUsage.add(AppUserUsage(
        appName: app.appName,
        appPackageName: app.appPackageName,
        appUsage: app.appUsage,
        appIcon: appIcon.icon,
        appAttributes: app.appAttributes
      ));
    }
    setState(() {
      _appUsage = newAppUsage;
      _isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    await getAppUsage();
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _onSendUsage() async {
    await context.read<AppUserUsageProvider>().sendAppUsage();
    getAppUsage();
  }

  @override
  Widget build(BuildContext context) {
    final usageProvider = context.watch<AppUserUsageProvider>();
    final isLoading = usageProvider.isLoading || _isLoading;
    final errorMessage = usageProvider.errorMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Usage'),
      ),
      body: StarryBackgroundWidget(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _onRefresh,
                child: errorMessage != null
                    ? ListView(
                        children: [
                          const SizedBox(height: 100),
                          Center(
                            child: Text(
                              errorMessage,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _appUsage.length,
                        itemBuilder: (context, index) {
                          final item = _appUsage[index];
                          return ListTile(
                            leading: (item.appIcon != null)
                                ? Image.memory(item.appIcon!)
                                : const Icon(Icons.apps),
                            title: Text(item.appName),
                            trailing: Text(formatDuration(item.appUsage)),
                          );
                        },
                      ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading ? null : _onSendUsage,
        child: const Icon(Icons.file_upload),
      ),
    );
  }
}
