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
                            width: 340, // Set the width of each card
                            height: 240, // Set the height of the container
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
                                DealWidget(deal: deal),
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

class DealWidget extends StatelessWidget {
  final Deal deal;
  const DealWidget({
    required this.deal,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
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
                child: deal.image != null
                    ? Image.network(
                        deal.image!,
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
                width: 16), // Add some spacing between the avatar and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    deal.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deal.partnerName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w200),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
