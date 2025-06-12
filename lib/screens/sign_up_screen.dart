import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sunny_chen_project/providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _signUp() async {
    try {
      await Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      ).signUp(_emailController.text, _passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use' && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Email already in use.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super Youth")),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 20,
              children: [
                Text("Sign Up", style: TextStyle(fontSize: 40)),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (String? email) {
                    if (email == null ||
                        !RegExp(
                          r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$',
                        ).hasMatch(email)) {
                      return 'Invalid email entered.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (String? username) {
                    if (username == null ||
                        username.length < 3 ||
                        username.length > 20) {
                      return 'Username must be between 3 and 20 characters long.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (String? password) {
                    if (password == null ||
                        !RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$',
                        ).hasMatch(password)) {
                      return 'Password must have the following:\n'
                          '- Minimum 8 characters long\n'
                          '- 1 uppercase letter\n'
                          '- 1 lowercase letter\n'
                          '- 1 number\n'
                          '- 1 special character';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  validator: (String? password) {
                    if (password != _passwordController.text) {
                      return 'Passwords must be matching';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logging in!')),
                      );
                      await _signUp();
                    }
                  },
                  child: Text("Sign Up"),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: Text("Back to Log In"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
