import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modeinvestorclub/src/data/globals.dart';
import 'package:provider/provider.dart';
import '../auth.dart';
import '../backend.dart';
import '../widgets/ui.dart'; // Ensure this import is correct

class SettingsScreen extends StatefulWidget {
  final ApiResponse? user;
  const SettingsScreen({super.key, this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0), // Add padding to start 20 pixels from the top
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: const Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                      child: SettingsContent(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<ModeAuth>(context);
    final user = auth.user;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16.0),
          Text('Name: ${user?.firstName ?? ''} ${user?.lastName ?? ''}'),
          const SizedBox(height: 8.0),
          Text('Email: ${user?.email ?? ''}'),
          const SizedBox(height: 26.0),
          RoundedButton(
            onPressed: () {
              auth.setTokenLogin(true);
              GoRouter.of(context).go('/home');
            },
            text: 'Change Password',
            color: transparentButton,
            icon: Icon(Icons.lock),
          ),
          const SizedBox(height: 20.0),
          RoundedButton(
            onPressed: () async {
              await auth.signOut();
              GoRouter.of(context).go('/sign-in');
            },
            text: 'Sign Out',
            color: transparentButton,
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
