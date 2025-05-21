import 'package:app_usage/app_usage.dart';
import 'package:brainwave/models/app_user_usage.dart';
import 'package:brainwave/services/app_user_usage_service.dart';
import 'package:flutter/foundation.dart';

class AppUserUsageProvider with ChangeNotifier{
  final AppUserUsageService _appUsageService = AppUserUsageService();

  bool _isLoading = false;
  String? _errorMessage;
  List<AppUserUsage> _appUsage = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<AppUserUsage> get appUsage => _appUsage;

  void setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message){
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> getAppUsage() async {
    setLoading(true);
    setErrorMessage(null);
    try{
      _appUsage = await _appUsageService.getAppUsage();
    } catch(e){
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> sendAppUsage() async {
    setLoading(true);
    setErrorMessage(null);
    try{
      DateTime now = DateTime.now().toUtc();
      final startDate = DateTime(now.year, now.month, now.day).toUtc();

      final usageInfo = await AppUsage().getAppUsage(startDate, now);
      await _appUsageService.sendAppUsage(usageInfo);
    } catch(e){
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }
  
}