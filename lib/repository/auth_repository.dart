import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/main.dart';

abstract class AuthRepository {
  Future<void> logIn(String email, String password);

  Future<void> signUp(String email, String password);

  Future<void> logOut();
}

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<void> logIn(String email, String password) async {
    try {
     await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      debugPrint("error log in: $e");
    }
  }

  @override
  Future<void> logOut() async {
    try {
    await  supabase.auth.signOut(scope: SignOutScope.global);
    } catch (e) {
      debugPrint("error log out: $e");
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    try {
      await supabase.auth.signUp(email: email, password: password);
    } catch (e) {
      debugPrint("error sign up: $e");
    }
  }
}
