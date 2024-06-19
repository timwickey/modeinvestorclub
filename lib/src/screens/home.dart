import 'package:flutter/material.dart';

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
              child: Padding(
                padding: const EdgeInsets.only(top: 38.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // Wide screen: one card 1/4 width, the other 3/4 width
                        return Row(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.25,
                              height: 200,
                              child: const TwentyCustomCard(),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: constraints.maxWidth * 0.75 - 8,
                              height: 200,
                              child: const ProfileCard(),
                            ),
                          ],
                        );
                      } else {
                        // Mobile screen: both cards full width
                        return Column(
                          children: const [
                            ProfileCard(),
                            SizedBox(height: 20),
                            TwentyCustomCard(),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) => Card(
        child: Row(
          children: [
            // Profile circle
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Replace with actual image URL
            ),
            const SizedBox(width: 16),
            // Name and address
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Your Address',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      );
}

class FancyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const FancyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade400, Colors.orange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: Colors.white,
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      children: [
                        ProfileWidget(),
                      ],
                    ),
                    Column(
                      children: [
                        FancyButton(
                            text: "VIEW SHARES →",
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('View Shares Button pressed')),
                              );
                            }),
                      ],
                    )
                  ],
                ),
                Divider(thickness: .5),
                Row(),
              ],
            ),
          ),
        ),
      );
}

class TwentyCustomCard extends StatelessWidget {
  const TwentyCustomCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Container(
            height: 200, // Set the height of the container
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get \$20 in Shares',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'For every qualified member you invite! Terms apply.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(), // Use Spacer to push the button to the bottom
                Align(
                  alignment: Alignment.bottomRight,
                  child: FancyButton(
                      text: "Invite + Earn",
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invite + Earn')),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      );
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: HomeScreen(),
    ),
  ));
}
