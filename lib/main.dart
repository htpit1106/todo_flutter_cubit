import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/app.dart';
import 'package:todo_app/configs/app_constants.dart';
import 'package:intl/date_symbol_data_local.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_US', null);
  await Supabase.initialize(url: AppConstants.urlSupabase, anonKey: AppConstants.anonKeySupabase);
  runApp(TodoApp());
}
