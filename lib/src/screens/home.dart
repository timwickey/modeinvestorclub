import 'package:flutter/material.dart';
import 'package:modeinvestorclub/src/backend.dart';

import '../data/deal.dart';
import '../data/event.dart';
import '../widgets/deal_list.dart';
import '../widgets/event_list.dart';
import '../data/globals.dart';
import '../widgets/ui.dart';
import 'package:intl/intl.dart'; // Import the intl package

class HomeScreen extends StatefulWidget {
  final ApiResponse? user;

  const HomeScreen({required this.user, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// create a temporary list of deals
List<Deal> deals = [
  Deal(
    id: 1,
    title: 'Great Deal',
    image: null, // Replace with null to test the icon fallback
    partnerName: 'Partner Name',
    price: 50.0,
    originalPrice: 99,
    url: 'https://example.com',
  ),
  Deal(
    id: 2,
    title: 'Another Great Deal',
    image: null, // Replace with null to test the icon fallback
    partnerName: 'Partner Name',
    price: 50.0,
    originalPrice: 499,
    url: 'https://example.com',
  ),
  Deal(
    id: 3,
    title: 'Deal 3',
    image: null, // Replace with null to test the icon fallback
    partnerName: 'Partner Name',
    price: 50.0,
    originalPrice: 50,
    url: 'https://example.com',
  ),
];

// create a list of events
List<Event> events = [
  Event(
    id: 1,
    title: 'Event 1',
    image: null, // Replace with null to test the icon fallback
    partnerName: 'Partner Name',
    date: DateTime.now().add(const Duration(days: 10)),
    time: DateTime.now(),
    description: 'Description',
    url: 'https://example.com',
  ),
  Event(
    id: 2,
    title: 'Event 2',
    image: null, // Replace with null to test the icon fallback
    partnerName: 'Partner Name',
    date: DateTime.now().add(const Duration(days: 24)),
    time: DateTime.now(),
    description: 'Description',
    url: 'https://example.com',
  ),
  Event(
    id: 3,
    title: 'Event 3',
    image: null, // Replace with null to test the icon fallback
    partnerName: 'Partner Name',
    date: DateTime.now().add(const Duration(days: 32)),
    time: DateTime.now(),
    description: 'Description',
    url: 'https://example.com',
  ),
];

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
                  constraints: const BoxConstraints(maxWidth: pageWidth),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // calculate how much space is needed for the deals so we know how big to make the widget (for scrolling)
                      // we can fit 1 deal card within dealWidth
                      int numberOfDealsperRow =
                          (constraints.maxWidth / (dealWidth + dealSpacing))
                              .floor();
                      int numberOfRows =
                          (deals.length / numberOfDealsperRow).ceil();
                      double dealTotalHeight =
                          numberOfRows * (dealHeight + dealSpacing);
                      // add the space needed for the header of the deals widget and the footerbar
                      dealTotalHeight += 100.0;

                      if (constraints.maxWidth > 800) {
                        // Wide screen: one card 1/4 width, the other 3/4 width
                        return Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * 0.25,
                                  height: widgetHeight,
                                  child: const ReferralCard(),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: constraints.maxWidth * 0.75 - 8,
                                  height: widgetHeight,
                                  child: ProfileCard(user: widget.user),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth,
                                  height: 440,
                                  child: EventList(events: events),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth,
                                  height: dealTotalHeight,
                                  child: DealList(deals: deals),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Mobile screen: both cards full width
                        return Column(
                          children: [
                            SizedBox(
                              height: widgetHeightMobile,
                              child: ProfileCardMobile(user: widget.user),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: widgetHeightMobile,
                              child: const ReferralCardMobile(),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth,
                                  height: 440,
                                  child: EventList(events: events),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: dealTotalHeight,
                              child: DealList(deals: deals),
                            ),
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
                padding: const EdgeInsets.all(16.0),
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
                padding: const EdgeInsets.only(right: 8.0),
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

class ReferralCard extends StatelessWidget {
  const ReferralCard({
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Invite + Earn Button Pressed')),
                        );
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Invite + Earn Button Pressed')),
                        );
                      },
                    )),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: HomeScreen(
        user: ApiResponse(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@example.com',
          message: 'Welcome to Mode Investor Club',
          token: 'token',
          investments: [],
        ),
      ),
    ),
  ));
}
