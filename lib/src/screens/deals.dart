import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import '../backend.dart';
import '../widgets/deal_list.dart';
import '../data/globals.dart';

import '../auth.dart';

// List<Deal> deals = [
//   Deal(
//     id: 1,
//     title: 'Great Deal',
//     image: null, // Replace with null to test the icon fallback
//     partnerName: 'Partner Name',
//     price: 50.0,
//     originalPrice: 99,
//     url: 'https://example.com',
//   ),
//   Deal(
//     id: 2,
//     title: 'Another Great Deal',
//     image: null, // Replace with null to test the icon fallback
//     partnerName: 'Partner Name',
//     price: 50.0,
//     originalPrice: 499,
//     url: 'https://example.com',
//   ),
//   Deal(
//     id: 3,
//     title: 'Deal 3',
//     image: null, // Replace with null to test the icon fallback
//     partnerName: 'Partner Name',
//     price: 50.0,
//     originalPrice: 50,
//     url: 'https://example.com',
//   ),
// ];

class DealsScreen extends StatefulWidget {
  final ApiResponse? user;
  const DealsScreen({super.key, this.user});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
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

                      if (constraints.maxWidth > 800) {
                        // Wide screen
                        return Row(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth,
                              height: dealTotalHeight,
                              child: DealList(deals: widget.user?.deals ?? []),
                            ),
                          ],
                        );
                      } else {
                        // Mobile screen
                        return Column(
                          children: [
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
