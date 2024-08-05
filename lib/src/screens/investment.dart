import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/globals.dart';
import '../widgets/ui.dart'; // Ensure this import is correct
import '../backend.dart';
import '../auth.dart';

class InvestmentScreen extends StatefulWidget {
  final ApiResponse? user;
  const InvestmentScreen({super.key, this.user});

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0), // Start 20 pixels from the top
                    InvestmentList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InvestmentList extends StatelessWidget {
  const InvestmentList({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<ModeAuth>(context);
    final investments = auth.user?.investments ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          investments.map((investment) => InvestmentCard(investment)).toList(),
    );
  }
}

class InvestmentCard extends StatelessWidget {
  final Investment investment;

  const InvestmentCard(this.investment, {super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMd();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Round: ${investment.round}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Price: \$${investment.price.toStringAsFixed(2)}'),
            Text('Shares: ${investment.shares}'),
            Text('Bonus Shares: ${investment.bonusShares}'),
            Text(
                'Effective Price: \$${investment.effectivePrice.toStringAsFixed(2)}'),
            Text('Class: ${investment.shareClass}'),
            Text('Date: ${dateFormat.format(investment.date)}'),
          ],
        ),
      ),
    );
  }
}
