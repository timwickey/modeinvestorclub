import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

import '../auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    child: HomeContent(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            height: 200,
            width: 800,
            child: Row(
              children: [
                // 1/4 Section
                Container(
                  width: 200, // 1/4 of 800
                  color: Colors.grey[200],
                ),
                // 3/4 Section
                Container(
                  width: 600, // 3/4 of 800
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tim Wickey'),
                              Text('123 Home Address'),
                            ],
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              // Your onPressed logic here
                            },
                            child: const Text('View Shares'),
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        '37,456 shares owned',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Mode Mobile, INC\nClass AAA Common Stock',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          ),
        ],
      );
}
