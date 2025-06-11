import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logIn(_emailController.text, _passwordController.text);

      if (mounted) {
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Login", style: TextStyle(fontSize: 40)),
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
