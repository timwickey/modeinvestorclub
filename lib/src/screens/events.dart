import 'package:flutter/material.dart';

import '../widgets/event_list.dart';
import '../data/globals.dart';
import '../backend.dart';

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
