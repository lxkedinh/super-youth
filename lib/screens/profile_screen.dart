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
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      await authProvider.updateProfile(
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _deleteAccount() async {
    try {
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Are you sure you want to delete your account?"),
          action: SnackBarAction(
            label: "Yes",
            onPressed: () async {
              await authProvider.deleteAccount();
              if (!mounted) return;
              context.go('/login');
            },
          ),
        ),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget _buildExpBar(int level, int xp) {
    int xpCost = 15 + 5 * (level - 1);
    double progress = xp / xpCost;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: LinearProgressIndicator(
        value: progress,
        color: Colors.cyan,
        backgroundColor: ColorScheme.of(context).primary,
      ),
    );
  }

  Widget _buildEditProfileSection() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsetsGeometry.symmetric(horizontal: 40),
        child: Column(
          spacing: 40,
          children: [
            TextFormField(
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
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (String? firstName) {
                if (firstName == null ||
                    firstName.isEmpty ||
                    firstName.length > 20) {
                  return 'First name must be non-empty and less than 20 characters long.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (String? lastName) {
                if (lastName == null ||
                    lastName.isEmpty ||
                    lastName.length > 20) {
                  return 'Last name must be non-empty and less than 20 characters long.';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveProfile();
              },
              child: Text("Update Profile"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
              },
              label: Text("Back"),
              icon: Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
    );
  }

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
              String firstName = auth.userData?['firstName'] ?? '';
              String lastName = auth.userData?['lastName'] ?? '';
              int level = auth.userData?['level'];
              int xp = auth.userData?['xp'];

              return Column(
                spacing: 20,
                children: [
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  if (!_isEditing) ...[
                    Text(
                      '$firstName $lastName',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      "Level $level",
                      style: TextTheme.of(context).headlineMedium,
                    ),
                    _buildExpBar(level, xp),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      label: Text("Edit Profile"),
                      icon: Icon(Icons.edit),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _deleteAccount();
                      },
                      label: Text("Delete Account"),
                      icon: Icon(Icons.delete),
                    ),
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
                  ] else
                    _buildEditProfileSection(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
