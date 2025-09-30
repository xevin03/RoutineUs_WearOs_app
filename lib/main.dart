import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wearos_app/screen/main_screen.dart';
import 'package:wearos_app/screen/splash_screen/splash_screen.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WearOS App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: '/',
      home: const SplashScreen(), // ✅ 여기서 내가 만든 스플래시 띄움
      routes: {'/main': (_) => const MainScreen()},
    );
  }
}
