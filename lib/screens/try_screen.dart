import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sunny_chen_project/data/unit.dart';
import 'package:sunny_chen_project/services/ai_service.dart';

class TryScreen extends StatefulWidget {
  final int unitId;

  const TryScreen({super.key, required this.unitId});

  @override
  State<StatefulWidget> createState() => _TryScreenState();
}

class _TryScreenState extends State<TryScreen> {
  late final AIService ai;

  @override
  void initState() {
    super.initState();
    ai = AIService();
  }

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
          future: ai.generateContent(units[widget.unitId - 1].name),
          builder: (
            BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot,
          ) {
            if (snapshot.hasData) {
              return Container(
                margin: EdgeInsetsGeometry.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          snapshot.data!['response'],
                          style: TextTheme.of(context).bodyLarge,
                        ),
                      ),
                    ),
                    SizedBox(height: 400, child: TextField(maxLines: null)),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Could not generate content. Try again.",
                    style: TextTheme.of(context).bodyLarge?.apply(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  Text(
                    "Generating content",
                    style: TextTheme.of(context).displaySmall,
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
