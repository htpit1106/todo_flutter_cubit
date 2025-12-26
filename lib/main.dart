import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/app.dart';

import 'package:todo_app/services/supabase_service.dart';
import 'package:intl/date_symbol_data_local.dart';

final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_US', null);
  await Supabase.initialize(url: SupabaseService.url, anonKey: SupabaseService.anonKey);
  runApp(TodoApp());
}
