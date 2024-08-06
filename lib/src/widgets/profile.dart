import 'package:flutter/material.dart';
import 'package:modeinvestorclub/src/widgets/ui.dart';
import '../backend.dart';
import '../data/globals.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:go_router/go_router.dart';

class ProfileWidget extends StatelessWidget {
  final ApiResponse? user;

  const ProfileWidget({
    required this.user,
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
                    '${user?.firstName} ${user?.lastName}',
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

class ProfileCard extends StatelessWidget {
  final ApiResponse? user;

  const ProfileCard({
    required this.user,
    super.key,
  });

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
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Row(
                  children: [
                    ProfileWidget(user: user),
                    Spacer(),
                    SquaredButton(
                      text: "VIEW SHARES",
                      icon: const Icon(Icons.arrow_right_alt),
                      onPressed: () {
                        GoRouter.of(context).go('/investment');
                      },
                    ),
                  ],
                ),
              ),
              const Divider(thickness: borderThickness, color: borderColor),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: PortfolioValueWidget(user: user),
                ),
              ),
            ],
          ),
        ),
      );
}

class ProfileCardMobile extends StatelessWidget {
  final ApiResponse? user;

  const ProfileCardMobile({
    required this.user,
    super.key,
  });

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Row(
                  children: [
                    ProfileWidget(user: user),
                    Spacer(),
                    SquaredButton(
                      text: "VIEW SHARES",
                      icon: const Icon(Icons.arrow_right_alt),
                      onPressed: () {
                        GoRouter.of(context).go('/investment');
                      },
                    ),
                  ],
                ),
              ),
              const Divider(thickness: borderThickness, color: borderColor),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: PortfolioValueMobileWidget(user: user),
                ),
              ),
            ],
          ),
        ),
      );
}

class PortfolioValueWidget extends StatelessWidget {
  final ApiResponse? user;

  const PortfolioValueWidget({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final totalShares = user?.calculateTotalShares() ?? 0;
    final portfolioValue =
        totalShares * 0.16; // Assuming price per share is 0.16
    final previousValue = totalShares *
        0.15; // Assuming previous price per share is 0.15 for gains calculation
    final gainValue = portfolioValue - previousValue;
    final formattedValue = NumberFormat.simpleCurrency().format(portfolioValue);
    final formattedGain = NumberFormat.simpleCurrency().format(gainValue);

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  formattedValue,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 60.0),
                ),
                SizedBox(width: 8.0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  gainValue > 0 ? Icons.arrow_upward : Icons.horizontal_rule,
                  color: gainValue > 0 ? Colors.green : Colors.grey,
                  size: 24.0,
                ),
                SizedBox(width: 4.0),
                Text(
                  formattedGain,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: gainValue > 0 ? Colors.green : Colors.grey,
                      ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 34.0),
                  child: Text(
                    'Mode Mobile, INC',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.grey.shade400),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioValueMobileWidget extends StatelessWidget {
  final ApiResponse? user;

  const PortfolioValueMobileWidget({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final totalShares = user?.calculateTotalShares() ?? 0;
    final portfolioValue =
        totalShares * 0.16; // Assuming price per share is 0.16
    final previousValue = totalShares *
        0.15; // Assuming previous price per share is 0.15 for gains calculation
    final gainValue = portfolioValue - previousValue;
    final formattedValue = NumberFormat.simpleCurrency().format(portfolioValue);
    final formattedGain = NumberFormat.simpleCurrency().format(gainValue);

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  formattedValue,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 40.0),
                ),
                // SizedBox(width: 8.0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  gainValue > 0 ? Icons.arrow_upward : Icons.horizontal_rule,
                  color: gainValue > 0 ? Colors.green : Colors.grey,
                  size: 20.0,
                ),
                // SizedBox(width: 4.0),
                Text(
                  formattedGain,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: gainValue > 0 ? Colors.green : Colors.grey,
                      ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 34.0),
                  child: Text(
                    'Mode Mobile, INC',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.grey.shade400),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
