import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

// import '../data/event.dart';
import '../widgets/event_list.dart';
import '../data/globals.dart';
import '../backend.dart';

import '../auth.dart';

// create a list of events
// List<Event> events = [
//   Event(
//     id: 1,
//     title: 'Event 1',
//     image: null, // Replace with null to test the icon fallback
//     partnerName: 'Partner Name',
//     date: DateTime.now().add(const Duration(days: 10)),
//     time: DateTime.now(),
//     description: 'Description',
//     url: 'https://example.com',
//   ),
//   Event(
//     id: 2,
//     title: 'Event 2',
//     image: null, // Replace with null to test the icon fallback
//     partnerName: 'Partner Name',
//     date: DateTime.now().add(const Duration(days: 24)),
//     time: DateTime.now(),
//     description: 'Description',
//     url: 'https://example.com',
//   ),
//   Event(
//     id: 3,
//     title: 'Event 3',
//     image: null, // Replace with null to test the icon fallback
//     partnerName: 'Partner Name',
//     date: DateTime.now().add(const Duration(days: 32)),
//     time: DateTime.now(),
//     description: 'Description',
//     url: 'https://example.com',
//   ),
// ];

class EventsScreen extends StatefulWidget {
  final ApiResponse? user;
  const EventsScreen({super.key, this.user});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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
                      // calculate how much space is needed for the events so we know how big to make the widget (for scrolling)
                      double eventTotalHeight =
                          (widget.user?.events.length ?? 0) * 150.0;
                      // add the space needed for the header of the events widget and the footerbar
                      eventTotalHeight += 100.0;

                      if (constraints.maxWidth > 800) {
                        // Wide screen
                        return Row(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth,
                              height: eventTotalHeight,
                              child:
                                  EventList(events: widget.user?.events ?? []),
                            ),
                          ],
                        );
                      } else {
                        // Mobile screen
                        return Column(
                          children: [
                            SizedBox(height: 8),
                            SizedBox(
                              height: eventTotalHeight,
                              child:
                                  EventList(events: widget.user?.events ?? []),
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
