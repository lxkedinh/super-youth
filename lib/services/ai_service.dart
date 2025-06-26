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
                "Generate a challenging social scenario about $unitTitle asking the user what they would do in that situation.",
          }),
        ],
      );

      final response = await openAI.onChatCompletion(request: request);
      final message = response?.choices.first.message;
      if (message != null) {
        print(message);
        return Map.of({"response": message});
      } else {
        throw Exception('Error generating content: No response');
      }
    } on Exception catch (e) {
      throw Exception('Error generating content: $e');
    }
  }
}
