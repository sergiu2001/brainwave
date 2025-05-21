import 'package:brainwave/models/user_report.dart';
import 'package:brainwave/services/user_report_service.dart';
import 'package:flutter/foundation.dart';

class UserReportProvider with ChangeNotifier{
  final UserReportService _userReportService = UserReportService();

  bool _isLoading = false;
  String? _errorMessage;
  List<UserReport> _userReports = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<UserReport> get userReports => _userReports;


  void setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message){
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> getUserReports() async {
    setLoading(true);
    setErrorMessage(null);
    try{
      _userReports = await _userReportService.getUserReports();
    } catch(e){
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> sendReport({
    required List<Map<String,dynamic>> apps,
    required List<String> dailyActivities,
    required Map<String,int> mentalHealthQuestions,
    required List<double> predictions,
  }) async {
    setLoading(true);
    setErrorMessage(null);
    try{
      await _userReportService.sendUserReport(
        apps: apps,
        dailyActivities: dailyActivities,
        mentalHealthQuestions: mentalHealthQuestions,
        predictions: predictions,
      );
      await getUserReports();
    } catch(e){
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }
}