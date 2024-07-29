import 'package:flutter/material.dart';
import 'package:modeinvestorclub/src/widgets/ui.dart';
import '../backend.dart';
import '../data/globals.dart';
import 'package:intl/intl.dart';

class EventList extends StatelessWidget {
  final List<Event> events;
  final ValueChanged<Event>? onTap;

  const EventList({
    required this.events,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.event_available, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: pageWidth),
              child: Column(
                children: [
                  for (var event in events) ...[
                    const Divider(thickness: 1.0, color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: ClipOval(
                                      child: (event.image != null &&
                                              event.image!.isNotEmpty)
                                          ? Image.network(
                                              event.image!,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(
                                              Icons.local_offer,
                                              size: 40,
                                              color: Colors.blue,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          16), // Add some spacing between the avatar and text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          event.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          event.partnerName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('yyyy-MM-dd').format(event.date),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: RoundedButton(
                              text: "EVENT PAGE",
                              color: transparentButton,
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                onTap?.call(event);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Divider(
                      thickness: 1.0,
                      color: Colors.grey), // Add the final divider
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
