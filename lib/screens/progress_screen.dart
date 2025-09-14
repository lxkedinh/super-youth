import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunny_chen_project/providers/auth_provider.dart';
import 'package:sunny_chen_project/widgets/nav_drawer.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late Future<List<double>> unitAvgScores;

  @override
  void initState() {
    super.initState();
    unitAvgScores =
        Provider.of<AuthenticationProvider>(
          context,
          listen: false,
        ).getAverageScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text("Super Youth")),
      body: Center(
        child: FutureBuilder(
          future: unitAvgScores,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<double>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                spacing: 20,
                children: [
                  Text("Progress", style: TextTheme.of(context).displaySmall),
                  for (int i = 0; i < snapshot.data!.length; i++)
                    Card(
                      color: Theme.of(context).primaryColor,
                      child: SizedBox(
                        height: 75,
                        width: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Unit ${i + 1} Average Score",
                                style: TextTheme.of(context).bodyLarge,
                              ),
                              Text(
                                "${snapshot.data![i]}",
                                style: TextTheme.of(context).headlineLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
