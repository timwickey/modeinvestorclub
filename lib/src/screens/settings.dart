import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modeinvestorclub/src/data/globals.dart';
import 'package:url_launcher/link.dart';
import '../auth.dart';
import '../widgets/ui.dart'; // Ensure this import is correct

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    child: SettingsContent(),
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
  Widget build(BuildContext context) => Column(
        children: [
          ...[
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: 16.0,
            ),
            const Text('Example using the Link widget:'),
            Link(
              uri: Uri.parse('/home'),
              builder: (context, followLink) => TextButton(
                onPressed: followLink,
                child: const Text('/home'),
              ),
            ),
            const Text('Example using GoRouter.of(context).go():'),
            TextButton(
              child: const Text('/deals'),
              onPressed: () {
                GoRouter.of(context).go('/deals');
              },
            ),
          ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
          const Text('Displays a dialog on the root Navigator:'),
          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Alert!'),
                content: const Text('The alert description goes here.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
            child: const Text('Show Dialog'),
          ),
          SizedBox(
            height: 20.0,
          ),
          RoundedButton(
            onPressed: () {
              ModeAuth.of(context).signOut();
            },
            text: 'Sign Out',
            color: transparentButton,
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      );
}
