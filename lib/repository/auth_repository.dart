import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {


  Future<void> logIn(String email, String password);

  Future<void> signUp(String email, String password);

  Future<void> logOut();
  bool isLoggedIn();
}

class AuthRepositoryImpl extends AuthRepository {
  final  _supabase = Supabase.instance.client ;


  @override
  bool isLoggedIn() {
    return _supabase.auth.currentSession != null;
  }
  @override
  Future<void> logIn(String email, String password) async {
    try {
     await _supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      debugPrint("error log in: $e");
    }
  }

  @override
  Future<void> logOut() async {
    try {
    await  _supabase.auth.signOut(scope: SignOutScope.global);
    } catch (e) {
      debugPrint("error log out: $e");
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
    } catch (e) {
      debugPrint("error sign up: $e");
    }
  }
}
