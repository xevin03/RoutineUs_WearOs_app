import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Routine {
  final int missionId;
  final String title;
  final String description;
  final String category;
  final bool active;

  Routine({
    required this.missionId,
    required this.title,
    required this.description,
    required this.category,
    required this.active,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      missionId: json['missionId'],
      title: json['title']?.toString() ?? '제목 없음', // ✅ 안전하게
      description: json['description']?.toString() ?? '',
      category: json['category'] ?? '알 수 없음',
      active: json['active'] ?? false,
    );
  }

  static List<Routine> fromJsonList(List<dynamic> list) {
    return list.map((json) => Routine.fromJson(json)).toList();
  }
}

class RoutineFetchResult {
  final List<Routine> routines;
  final int totalLevel;

  RoutineFetchResult({required this.routines, required this.totalLevel});
}

Future<RoutineFetchResult> fetchRoutines() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');

  if (token == null) {
    debugPrint('[ROUTINE_API] ❌ 토큰 없음');
    throw Exception('토큰이 없습니다. 로그인 필요.');
  }

  final baseUrl = dotenv.env['BASE_URL'];
  if (baseUrl == null) {
    debugPrint('[ROUTINE_API] ❌ BASE_URL 없음');
    throw Exception('BASE_URL이 설정되지 않았습니다.');
  }

  final url = Uri.parse('$baseUrl/routine/calendar');
  debugPrint('[ROUTINE_API] 📡 요청 URL: $url');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  debugPrint('[ROUTINE_API] 📬 응답 코드: ${response.statusCode}');
  debugPrint('[ROUTINE_API] 📦 응답 본문: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final routinesJson = data['routines'];
    final totalLevel = data['levelInfo']['totalLevel'] ?? 0;

    debugPrint('[ROUTINE_API] ✅ 루틴 개수: ${routinesJson.length}');
    debugPrint('[ROUTINE_API] ✅ 총 레벨: $totalLevel');

    return RoutineFetchResult(
      routines: Routine.fromJsonList(routinesJson),
      totalLevel: totalLevel,
    );
  } else {
    debugPrint('[ROUTINE_API] ❌ 실패 응답: ${response.body}');
    throw Exception('루틴 불러오기 실패: ${response.body}');
  }
}
