import 'package:flutter/material.dart';
import 'package:modeinvestorclub/src/widgets/ui.dart';
import '../backend.dart';
import '../data/globals.dart';
import 'package:intl/intl.dart'; // Import the intl package

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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('View Shares Button pressed'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 2.0),
                child: Text(
                  'If you have not set up your transfer online account, "123456" is your personal access code. Use it to create your account.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(thickness: borderThickness, color: borderColor),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SharesWidget(user: user),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ShareClassWidget(user: user),
                        ],
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('View Shares Button pressed'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 2.0),
                child: Text(
                  'If you have not set up your transfer online account, "123456" is your personal access code. Use it to create your account.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(thickness: borderThickness, color: borderColor),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SharesWidgetMobile(user: user),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ShareClassWidgetMobile(user: user),
                        ],
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

class SharesWidget extends StatelessWidget {
  final ApiResponse? user;
  const SharesWidget({
    required this.user,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final totalShares = user?.calculateTotalShares() ?? 0;
    final formattedShares = NumberFormat('#,###').format(totalShares);
    return Card(
      child:

          // Name and address
          Padding(
        padding: const EdgeInsets.only(left: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedShares,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 60.0),
            ),
            Text(
              'Shares Owned',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class SharesWidgetMobile extends StatelessWidget {
  final ApiResponse? user;
  const SharesWidgetMobile({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final totalShares = user?.calculateTotalShares() ?? 0;
    final formattedShares = NumberFormat('#,###').format(totalShares);
    // final estimatedPrice = totalShares * 0.16;
    // final formattedPrice = NumberFormat.simpleCurrency().format(estimatedPrice);

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedShares,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 40.0),
            ),
            Text(
              'Shares Owned',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class ShareClassWidget extends StatelessWidget {
  final ApiResponse? user;
  const ShareClassWidget({
    required this.user,
    super.key,
  });
  @override
  Widget build(BuildContext context) => Card(
        child:

            // Name and address
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Mode Mobile, INC',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Class AAA Common Stock',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      );
}

class ShareClassWidgetMobile extends StatelessWidget {
  final ApiResponse? user;
  const ShareClassWidgetMobile({
    required this.user,
    super.key,
  });
  @override
  Widget build(BuildContext context) => Card(
        child:

            // Name and address
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Mode Mobile, INC',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Class AAA Common Stock',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      );
}
