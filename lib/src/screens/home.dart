import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// declare a constant
const widgetheight = 300.0;

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
                              height: widgetheight,
                              child: const TwentyCustomCard(),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: constraints.maxWidth * 0.75 - 8,
                              height: widgetheight,
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

class SharesWidget extends StatelessWidget {
  const SharesWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) => Card(
        child:

            // Name and address
            Container(
          color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '37,456',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                'Shares Owned',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
}

class ShareClassWidget extends StatelessWidget {
  const ShareClassWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) => Card(
        child:

            // Name and address
            Container(
          color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mode Mobile, INC',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                'Class AAA Common Stock',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
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
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(
                  width: 16), // Add some spacing between the avatar and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Name',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your Address',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w200),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class FancyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double maxHeight;
  final double maxWidth;

  const FancyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.maxHeight = 60.0,
    this.maxWidth = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      ),
      child: Container(
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
            borderRadius: BorderRadius.circular(10.0),
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
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: const Color.fromARGB(255, 79, 28, 24),
                        child: Center(child: ProfileWidget()),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: const Color.fromARGB(255, 9, 14, 10),
                        child: Center(
                          child: FancyButton(
                              text: "VIEW SHARES →",
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('View Shares Button pressed')),
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: .5),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: const Color.fromARGB(255, 10, 14, 16),
                        child: Center(child: SharesWidget()),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: const Color.fromARGB(255, 32, 30, 14),
                        child: Center(child: ShareClassWidget()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
