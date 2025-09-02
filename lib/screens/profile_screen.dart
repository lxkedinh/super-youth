import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sunny_chen_project/providers/auth_provider.dart';
import 'package:sunny_chen_project/widgets/nav_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: const Text('Super Youth')),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 40),
          child: Consumer<AuthenticationProvider>(
            builder: (context, auth, _) {
              String firstName = auth.userData?['firstName'];
              String lastName = auth.userData?['lastName'];
              String email = auth.userData?['email'];
              String username = auth.userData?['username'];

              return Column(
                spacing: 20,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: Text(
                      'Profile',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const Image(
                    image: AssetImage('assets/images/blank_avatar.webp'),
                    width: 100,
                  ),
                  Text(
                    '$firstName $lastName',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    username,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text('Email: $email'),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
