import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sunny_chen_project/data/unit.dart';

class UnitScreen extends StatelessWidget {
  final int id;

  const UnitScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Unit unit = units[id - 1];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Youth'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(child: Text(unit.name)),
    );
  }
}
