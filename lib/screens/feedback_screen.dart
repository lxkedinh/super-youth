import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sunny_chen_project/providers/ai_provider.dart';

import '../data/unit.dart';
import '../widgets/nav_drawer.dart';

class FeedbackScreen extends StatefulWidget {
  final String scenario;
  final int scenarioNumber;
  final String userResponse;
  final int unitNumber;

  const FeedbackScreen({
    super.key,
    required this.unitNumber,
    required this.scenarioNumber,
    required this.scenario,
    required this.userResponse,
  });

  @override
  State<StatefulWidget> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late Future<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
    data = Provider.of<AIProvider>(context, listen: false).generateFeedback(
      scenario: widget.scenario,
      userResponse: widget.userResponse,
    );
  }

  String _buildScoreMessage(int score) {
    if (score >= 9) {
      return "Amazing!";
    } else if (score >= 6) {
      return "Good job!";
    } else {
      return "Nice try!";
    }
  }

  String _buildBulletPoints(String title, List<dynamic> bulletPoints) {
    String output = "$title:\n";

    for (int i = 0; i < bulletPoints.length; i++) {
      String current = bulletPoints[i];
      output += "- $current\n";
    }

    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: const Text('Super Youth')),
      body: Center(
        child: FutureBuilder(
          future: data,
          builder: (
            BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> feedback = snapshot.data!;
              List<dynamic> pros = feedback['pros'];
              List<dynamic> cons = feedback['cons'];

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  spacing: 20,
                  children: [
                    Text(
                      "Score: ${feedback['score']} / 10",
                      style: TextTheme.of(context).headlineSmall,
                    ),
                    Text(
                      _buildScoreMessage(feedback['score']),
                      style: TextTheme.of(context).headlineSmall,
                    ),
                    if (pros.isNotEmpty)
                      Text(
                        _buildBulletPoints("Pros", pros),
                        style: TextTheme.of(context).bodyLarge,
                      ),
                    if (cons.isNotEmpty)
                      Text(
                        _buildBulletPoints("Cons", cons),
                        style: TextTheme.of(context).bodyLarge,
                      ),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.go("/unit/${widget.unitNumber}");
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text("Back to Unit ${widget.unitNumber}"),
                    ),
                    if (widget.scenarioNumber <
                        units[widget.unitNumber - 1].numScenarios)
                      ElevatedButton.icon(
                        onPressed: () {
                          context.go(
                            "/unit/${widget.unitNumber}/try/${widget.scenarioNumber + 1}",
                          );
                        },
                        icon: Icon(Icons.arrow_forward),
                        label: Text("Next Scenario"),
                      ),
                  ],
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
