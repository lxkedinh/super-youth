import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sunny_chen_project/providers/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();

  Future<void> _sendResetPasswordEmail() async {
    try {
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.sendResetPasswordEmail(_emailController.text);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password reset email sent!")));

      context.go('/login');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not send password reset email. Try again."),
        ),
      );
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
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 20,
              children: [
                Text("Reset Password", style: TextStyle(fontSize: 40)),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
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
                  controller: _confirmEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (String? email) {
                    if (email != _emailController.text) {
                      return 'Email must match.';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _sendResetPasswordEmail();
                    }
                  },
                  child: Text("Reset Password"),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
