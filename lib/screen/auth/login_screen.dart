import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearos_app/screen/main_screen.dart';
// import 'package:wearos_app/services/auth_api.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String statusMessage = '자동 로그인 중...';

  @override
  void initState() {
    super.initState();
    _mockLogin();
  }

  Future<void> _mockLogin() async {
    try {
    
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', 'mock_token');

      setState(() {
        statusMessage = '자동 로그인 되었습니다!';
      });

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      setState(() {
        statusMessage = '로그인 실패: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          statusMessage,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 82, 82, 82),
          ),
        ),
      ),
    );
  }
}
