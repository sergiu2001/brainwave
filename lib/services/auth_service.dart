import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String dob,
    required String height,
    required String weight,
    required String sex,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    } finally {
      final callable =
          FirebaseFunctions.instance.httpsCallable('updateAccount');
      await callable.call({
        'uid': _firebaseAuth.currentUser!.uid,
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob,
        'height': height,
        'weight': weight,
        'sex': sex
      });
    }
  }

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
  }

  Future<AppUser?> getUser() async {
    if (_firebaseAuth.currentUser == null) return null;
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('getUser');
      final response = await callable.call({
        'uid': _firebaseAuth.currentUser!.uid,
      });
      return AppUser.fromMap(response.data as Map<String, dynamic>, uid: _firebaseAuth.currentUser!.uid);
    } on FirebaseFunctionsException catch (e) {
      print(e);
      return null;
    }
  }
}
