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
            return Text("");
          },
        ),
      ),
    );
  }
}
