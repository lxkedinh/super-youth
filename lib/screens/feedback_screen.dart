import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sunny_chen_project/providers/ai_provider.dart';

class FeedbackScreen extends StatefulWidget {
  final String scenario;
  final String response;

  const FeedbackScreen({
    super.key,
    required this.scenario,
    required this.response,
  });

  @override
  State<StatefulWidget> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Youth'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: Provider.of<AIProvider>(
            context,
            listen: false,
          ).generateFeedback(
            scenario: widget.scenario,
            userResponse: widget.response,
          ),
          builder: (
            BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot,
          ) {
            if (snapshot.hasData) {
              Map<String, dynamic> feedback = snapshot.data!;
              return Column(
                children: [
                  Text("Score: ${feedback['score']}"),
                  Text("Comments: ${feedback['comments']}"),
                ],
              );
            }

            return Text("Generating feedback");
          },
        ),
      ),
    );
  }
}
