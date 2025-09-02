import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sunny_chen_project/data/unit.dart';
import 'package:sunny_chen_project/widgets/nav_drawer.dart';

class UnitScreen extends StatelessWidget {
  final int id;

  const UnitScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Unit unit = units[id - 1];

    List<Widget> actions = [];
    if (unit.id != units.last.id) {
      actions.add(
        IconButton(
          onPressed: () {
            context.push("/unit/${id + 1}");
          },
          icon: Icon(Icons.arrow_forward),
        ),
      );
    }

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('Super Youth'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: actions,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Unit $id", style: Theme.of(context).textTheme.displaySmall),
              Text(unit.name, style: Theme.of(context).textTheme.displaySmall),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  unit.description,
                  style: TextTheme.of(context).headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Learn",
                  style: TextTheme.of(context).headlineSmall,
                ),
              ),
              SizedBox(height: 30),
              Column(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 1; i <= unit.numScenarios; i++)
                    ElevatedButton(
                      onPressed: () {
                        context.push("/unit/$id/try/$i");
                      },
                      child: Text(
                        "Scenario $i",
                        style: TextTheme.of(context).headlineSmall,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
