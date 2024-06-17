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
                            Container(
                              width: constraints.maxWidth * 0.25,
                              child: const TwentyCustomCard(),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: constraints.maxWidth * 0.75,
                              child: const CustomCard(),
                            ),
                          ],
                        );
                      } else {
                        // Mobile screen: both cards full width
                        return Column(
                          children: const [
                            CustomCard(),
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

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            children: [
              Container(
                height: 200,
                color: const Color.fromARGB(255, 185, 182, 182),
                child: Row(
                  children: [
                    // 1/4 Section
                    Container(
                      width: 200, // 1/4 of 800
                      color: const Color.fromARGB(255, 179, 31, 31),
                    ),
                    // 3/4 Section
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
  Widget build(BuildContext context) => Card(
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
                child: ElevatedButton(
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                  child: const Text('Invite + Earn'),
                ),
              ),
            ],
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
