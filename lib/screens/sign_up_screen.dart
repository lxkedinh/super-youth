import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Sign Up", style: TextStyle(fontSize: 40)),
              TextFormField(),
              TextButton(
                onPressed: () {
                  Provider.of<AuthenticationProvider>(context, listen: false);
                },
                child: Text("Go Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
