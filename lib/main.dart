import 'package:daily_money/my_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final url = dotenv.env['URL'];
  final anonKey = dotenv.env['ANNON_KEY'];

  if (url == null || anonKey == null) {
    throw Exception('URL and ANON_KEY must be set in .env file');
  }

  await Supabase.initialize(url: url, anonKey: anonKey);

  runApp(MyApp());
}