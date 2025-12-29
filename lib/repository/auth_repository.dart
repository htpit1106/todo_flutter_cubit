import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  final SupabaseClient supabase;
  AuthRepository({required this.supabase});

  Future<void> logIn(String email, String password);

  Future<void> signUp(String email, String password);

  Future<void> logOut();
  bool isLoggedIn();
}

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({required super.supabase});

  @override
  bool isLoggedIn() {
    return supabase.auth.currentSession != null;
  }
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
