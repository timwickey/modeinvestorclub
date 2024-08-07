import 'package:flutter/material.dart';
import 'package:modeinvestorclub/src/widgets/ui.dart';
import '../backend.dart';
import '../data/globals.dart';

class ReferralCard extends StatelessWidget {
  const ReferralCard({
    super.key,
  });

  void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: borderColor,
              width: borderThickness,
            ),
          ),
          title: Text('Coming Soon'),
          content:
              Text('Referrals are on the way...! Stayed tuned for updates!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(
              color: borderColor,
              width: borderThickness,
            ),
          ),
          child: Container(
            height: 200, // Set the height of the container
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.orange.withOpacity(0.3),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Get ',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text: '\$20',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        TextSpan(
                          text: ' in Shares',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'For every qualified member you invite! Terms apply.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Spacer(), // Use Spacer to push the button to the bottom
                Align(
                    alignment: Alignment.bottomCenter,
                    child: RoundedButton(
                      text: "Invite + Earn",
                      icon: Icon(Icons.group_add, color: Colors.white),
                      color: colorButton,
                      onPressed: () {
                        showComingSoonDialog(context);
                      },
                    )),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      );
}

class ReferralCardMobile extends StatelessWidget {
  const ReferralCardMobile({
    super.key,
  });

  void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Coming Soon'),
          content: Text('Referrals coming soon...!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(
              color: borderColor,
              width: borderThickness,
            ),
          ),
          child: Container(
            height: 200, // Set the height of the container
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.orange.withOpacity(0.3),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Get ',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text: '\$20',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        TextSpan(
                          text: ' in Shares',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'For every qualified member you invite! Terms apply.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Spacer(), // Use Spacer to push the button to the bottom
                Align(
                    alignment: Alignment.bottomCenter,
                    child: RoundedButton(
                      text: "Invite + Earn",
                      icon: Icon(Icons.group_add, color: Colors.white),
                      color: colorButton,
                      onPressed: () {
                        showComingSoonDialog(context);
                      },
                    )),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
}
