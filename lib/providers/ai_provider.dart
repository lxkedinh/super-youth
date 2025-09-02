import 'package:flutter/material.dart';
import 'package:sunny_chen_project/services/ai_service.dart';

class AIProvider extends ChangeNotifier {
  late final AIService _ai;

  AIProvider() {
    _ai = AIService();
  }

  Future<Map<String, dynamic>> generateContent(String unitTitle) async {
    return _ai.generateContent(unitTitle);
  }

  Future<Map<String, dynamic>> generateFeedback({
    required String scenario,
    required String userResponse,
  }) async {
    return await _ai.generateFeedback(
      scenario: scenario,
      userResponse: userResponse,
    );
  }
}
