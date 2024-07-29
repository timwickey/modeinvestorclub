import 'package:flutter/material.dart';
import 'package:modeinvestorclub/src/backend.dart';

import '../widgets/deal_list.dart';
import '../widgets/event_list.dart';
import '../data/globals.dart';
import '../widgets/referral.dart';
import '../widgets/profile.dart';
import '../widgets/mode_investor_club.dart';
import '../widgets/stock_history.dart';

class HomeScreen extends StatefulWidget {
  final ApiResponse? user;

  const HomeScreen({required this.user, super.key});

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
                  constraints: const BoxConstraints(maxWidth: pageWidth),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // calculate how much space is needed for the deals so we know how big to make the widget (for scrolling)
                      // we can fit 1 deal card within dealWidth
                      int numberOfDealsperRow =
                          (constraints.maxWidth / (dealWidth + dealSpacing))
                              .floor();
                      int numberOfRows = ((widget.user?.deals.length ?? 0) /
                              numberOfDealsperRow)
                          .ceil();
                      double dealTotalHeight =
                          numberOfRows * (dealHeight + dealSpacing);
                      // add the space needed for the header of the deals widget and the footerbar
                      dealTotalHeight += 100.0;

                      double eventheight = 120;

                      // profile height
                      double profileHeight = widgetHeight;
                      double referralHeight = widgetHeight;

                      if (constraints.maxWidth < 1200 &&
                          constraints.maxWidth > 800) {
                        eventheight = 120 + (1200 - constraints.maxWidth) / 6;
                      } else if (constraints.maxWidth <= 800) {
                        eventheight = 150;
                        profileHeight = widgetHeight - 50;
                        referralHeight = widgetHeight - 180;
                      }

                      // calculate space needed for events
                      double eventTotalHeight =
                          ((widget.user?.events.length ?? 0) * eventheight) +
                              140.0;

                      if (constraints.maxWidth > 800) {
                        // Wide screen: one card 1/4 width, the other 3/4 width
                        return Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * 0.25,
                                  height: referralHeight,
                                  child: const ReferralCard(),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: constraints.maxWidth * 0.75 - 8,
                                  height: profileHeight,
                                  child: ProfileCard(user: widget.user),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth * 0.75 - 8,
                                  height: widgetHeight,
                                  child: StockHistory(),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: constraints.maxWidth * 0.25,
                                  height: widgetHeight,
                                  child: const ModeInvestorClub(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth,
                                  height: eventTotalHeight,
                                  child: EventList(
                                      events: widget.user?.events ?? []),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth,
                                  height: dealTotalHeight,
                                  child:
                                      DealList(deals: widget.user?.deals ?? []),
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
                              height: profileHeight,
                              child: ProfileCardMobile(user: widget.user),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: referralHeight,
                              child: const ReferralCardMobile(),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth,
                                  height: eventTotalHeight,
                                  child: EventListMobile(
                                      events: widget.user?.events ?? []),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: dealTotalHeight,
                              child: DealList(deals: widget.user?.deals ?? []),
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

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       body: HomeScreen(
//         user: ApiResponse(
//           id: 1,
//           firstName: 'John',
//           lastName: 'Doe',
//           email: 'john.doe@example.com',
//           message: 'Welcome to Mode Investor Club',
//           forcePassChange: false,
//           token: 'token',
//           investments: [],
//           options: [],
//           deals: [],
//           events: [],
//         ),
//       ),
//     ),
//   ));
// }
