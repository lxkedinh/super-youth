import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sunny_chen_project/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _firstName;
  late String _lastName;
  late String _email;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    final userData = authProvider.userData;
    _firstName = userData?['firstName'] ?? '';
    _lastName = userData?['lastName'] ?? '';
    _email = userData?['email'] ?? '';
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
        child: Container(
          margin: EdgeInsetsGeometry.only(top: 40),
          child: Column(
            spacing: 40,
            children: [
              const Image(
                image: AssetImage('assets/images/blank_avatar.webp'),
                width: 100,
              ),
              Text(
                'Hello $_firstName $_lastName!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text('Email: $_email'),
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<AuthenticationProvider>(
                    context,
                    listen: false,
                  ).signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
