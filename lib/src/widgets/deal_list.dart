import 'package:flutter/material.dart';
import '../data/deal.dart';
import '../data/globals.dart';

class DealList extends StatelessWidget {
  final List<Deal> deals;
  final ValueChanged<Deal>? onTap;

  const DealList({
    required this.deals,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_offer, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Available Partner Perks',
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
              constraints: BoxConstraints(
                  maxWidth: pageWidth), // Constrain the width of the ListView
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      alignment: WrapAlignment.center,
                      children: deals.map((deal) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                              color: borderColor,
                              width: borderThickness,
                            ),
                          ),
                          child: Container(
                            width: 200, // Set the width of each card
                            height: 200, // Set the height of the container
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.orange.withOpacity(0.3),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deal.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  deal.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: onTap != null
                                        ? () => onTap!(deal)
                                        : null,
                                    child: Text('View Deal'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
