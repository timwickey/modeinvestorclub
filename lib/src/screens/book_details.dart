import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

import '../data.dart';

class DealDetailsScreen extends StatelessWidget {
  final Deal? deal;

  const DealDetailsScreen({
    super.key,
    this.deal,
  });

  @override
  Widget build(BuildContext context) {
    if (deal == null) {
      return const Scaffold(
        body: Center(
          child: Text('No deal found.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(deal!.title),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              deal!.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              deal!.author.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              child: const Text('View author (Push)'),
              onPressed: () {
                throw StateError('on Deal tapped');
              },
            ),
          ],
        ),
      ),
    );
  }
}
