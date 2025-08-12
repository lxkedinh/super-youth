import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sunny_chen_project/data/unit.dart';
import 'package:sunny_chen_project/providers/ai_provider.dart';

class TryScreen extends StatefulWidget {
  final int unitId;

  const TryScreen({super.key, required this.unitId});

  @override
  State<StatefulWidget> createState() => _TryScreenState();
}

class _TryScreenState extends State<TryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _responseController = TextEditingController();

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
          ).generateContent(units[widget.unitId - 1].name),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SingleChildScrollView(
                        child: Text(
                          snapshot.data!['scenario'],
                          style: TextTheme.of(context).bodyLarge,
                        ),
                      ),
                      TextFormField(
                        maxLines: 8,
                        controller: _responseController,
                        decoration: InputDecoration(
                          labelText: 'Response',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (String? response) {
                          if (response == null || response.isEmpty) {
                            return 'Response required.';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.push(
                              '/unit/${widget.unitId}/feedback',
                              extra: Map.of({
                                'scenario': snapshot.data!['scenario'],
                                'response': _responseController.text,
                              }),
                            );
                          }
                        },
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Could not generate scenario. Try again.",
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
                    "Generating scenario",
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
