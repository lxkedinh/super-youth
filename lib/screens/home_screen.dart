import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sunny_chen_project/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Super Youth'),
        actions: [
          IconButton(
            onPressed: () => context.go('/home/profile'),
            icon: Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/home_screen_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<AuthenticationProvider>(
                builder: (context, authProvider, _) {
                  final name = authProvider.userData?['firstName'] ?? 'there';

                  return Text(
                    "Hello $name!",
                    style: Theme.of(context).textTheme.displayLarge,
                  );
                },
              ),
              Text(
                "Your Journey",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text("Units", style: Theme.of(context).textTheme.displayMedium),
              Align(
                alignment: Alignment(0, 1),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "6",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.5, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "5",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "4",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.5, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "3",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "2",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.5, 0),
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/unit/1');
                  },
                  child: Text(
                    "1",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
