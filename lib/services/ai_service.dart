import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  late final OpenAI openAI;

  AIService() {
    openAI = OpenAI.instance.build(
      token: dotenv.env['OPENAI_KEY'],
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
    );
  }

  Future<Map<String, dynamic>> generateFeedback({
    required String scenario,
    required String userResponse,
  }) async {
    try {
      final request = ChatCompleteText(
        messages: [
          Map.of({
            "role": "system",
            "content":
                "You are an expert in social skills and youth"
                "development, providing detailed feedback on responses to social scenarios.",
          }),
          Map.of({
            "role": "user",
            "content": '''
Analyze the following response to a social scenario:

Scenario: $scenario
User Response: $userResponse

Refer to the user in the second person point of view and please provide feedback in the following JSON format:
{
  "score": (1-10 score based on appropriateness and effectiveness),
  "pros": "(array of strings of pros of the response in the second person perspective)",
  "cons": "(array of strings of cons of the response in the second person perspective)",
}
''',
          }),
        ],
        maxToken: 1000,
        model: Gpt4ChatModel(),
      );

      final feedback = await openAI.onChatCompletion(request: request);
      final message = feedback?.choices.first.message;
      if (message != null) {
        return jsonDecode(message.content);
      } else {
        throw Exception('Failed to generate feedback: No response content');
      }
    } catch (e) {
      throw Exception('Error generating feedback: $e');
    }
  }

  Future<Map<String, dynamic>> generateContent(String unitTitle) async {
    try {
      final request = ChatCompleteText(
        model: Gpt4OChatModel(),
        maxToken: 1000,
        messages: [
          Map.of({
            "role": "system",
            "content":
                "Act as an educational content creator for teenagers."
                "You make engaging and meaningful educational content for a youth learning platform.",
          }),
          Map.of({
            "role": "user",
            "content":
                "Generate a challenging social scenario about $unitTitle asking the user what they would do in that situation."
                "Respond with only a paragraph of the social scenario.",
          }),
        ],
      );

      final response = await openAI.onChatCompletion(request: request);
      final message = response?.choices.first.message;
      if (message != null) {
        return Map.of({"scenario": message.content});
      } else {
        throw Exception('Error generating content: No response');
      }
    } on Exception catch (e) {
      throw Exception('Error generating content: $e');
    }
  }
}
