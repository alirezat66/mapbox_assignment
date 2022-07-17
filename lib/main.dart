import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:spa_coding_exercise/core/api_client.dart';
import 'package:spa_coding_exercise/core/appearance/light_theme.dart';
import 'package:spa_coding_exercise/pages/start_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final client = ApiClient(Client());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPA Coding Exercise',
      theme: lightTheme,
      home: StartPage(),
    );
  }
}
