import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

import '../auth.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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
                    child: EventsContent(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class EventsContent extends StatelessWidget {
  const EventsContent({
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
            FilledButton(
              onPressed: () {
                ModeAuth.of(context).signOut();
              },
              child: const Text('Sign out'),
            ),
            const Text('Example using the Link widget:'),
            Link(
              uri: Uri.parse('/books/all/book/0'),
              builder: (context, followLink) => TextButton(
                onPressed: followLink,
                child: const Text('/books/all/book/0'),
              ),
            ),
            const Text('Example using GoRouter.of(context).go():'),
            TextButton(
              child: const Text('/books/all/book/0'),
              onPressed: () {
                GoRouter.of(context).go('/books/all/book/0');
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
          )
        ],
      );
}
