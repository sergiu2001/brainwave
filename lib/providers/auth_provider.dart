import 'package:brainwave/models/app_user.dart';
import 'package:brainwave/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
    final AuthService _authService = AuthService();

    bool _isLoading = false;
    String? _errorMessage;
    AppUser? _user;

    bool get isLoading => _isLoading;
    String? get errorMessage => _errorMessage;
    AppUser? get user => _user;
    bool get isAuthenticated => _authService.currentUser != null;

    void setLoading(bool value) {
        _isLoading = value;
        notifyListeners();
    }

    void setErrorMessage(String? message) {
        _errorMessage = message;
        notifyListeners();
    }

    Future<void> loadUser() async {
        if(!isAuthenticated) return;
        setLoading(true);
        setErrorMessage(null);
        try{
            _user = await _authService.getUser();
        } catch(e){
            setErrorMessage(e.toString());
        } finally {
            setLoading(false);
        }
    }

    Future<void> register({
        required String email,
        required String password,
        required String firstName,
        required String lastName,
        required String dob,
        required String height,
        required String weight,
        required String sex
        }) async {
            setLoading(true);
            setErrorMessage(null);
            try{
                await _authService.registerUser(
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName,
                    dob: dob,
                    height: height,
                    weight: weight,
                    sex: sex);
            } catch(e){
                setErrorMessage(e.toString());
            } finally {
                setLoading(false);
            }
        }
    
    Future<void> signIn(String email, String password) async {
        setLoading(true);
        setErrorMessage(null);
        try{
            await _authService.signInUser(email: email, password: password);
            await loadUser();
        } catch(e){
            setErrorMessage(e.toString());
        } finally {
            setLoading(false);
        }
    }

    Future<void> signOut() async {
        setLoading(true);
        setErrorMessage(null);
        try{
            await _authService.signOutUser();
            _user = null;
        } catch(e){
            setErrorMessage(e.toString());
        } finally {
            setLoading(false);
        }
    }
}