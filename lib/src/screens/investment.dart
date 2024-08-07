import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../backend.dart';
import '../auth.dart';
import '../data/globals.dart'; // Ensure this import is correct for pageWidth

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
                constraints: const BoxConstraints(maxWidth: pageWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                        height: 20.0), // Start 20 pixels from the top
                    const Text(
                      'Your Investments in Mode Mobile, INC',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    InvestmentSummaryCard(),
                    const Divider(thickness: 1.0),
                    const SizedBox(height: 20.0),
                    const InvestmentList(),
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

class InvestmentSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<ModeAuth>(context);
    final investments = auth.user?.investments ?? [];
    final stockPriceHistory = auth.user?.stockPriceHistory ?? [];
    final latestPrice =
        stockPriceHistory.isNotEmpty ? stockPriceHistory.last.price : 0.0;

    final totalShares =
        investments.fold<int>(0, (sum, investment) => sum + investment.shares);
    final bonusShares = investments.fold<int>(
        0, (sum, investment) => sum + investment.bonusShares);
    final totalSharesWithBonus = totalShares + bonusShares;
    final totalValuation = totalSharesWithBonus * latestPrice;

    final effectivePriceWithoutBonus = investments.fold<double>(0.0,
            (sum, investment) => sum + (investment.price * investment.shares)) /
        totalShares;
    final effectivePriceWithBonus = investments.fold<double>(
            0.0,
            (sum, investment) =>
                sum +
                (investment.price *
                    (investment.shares + investment.bonusShares))) /
        totalSharesWithBonus;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Shares: $totalShares',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Bonus Shares: $bonusShares'),
            Text('Total Shares with Bonus: $totalSharesWithBonus'),
            const SizedBox(height: 8.0),
            Text(
                'Effective Price per Share (without bonuses): \$${effectivePriceWithoutBonus.toStringAsFixed(2)}'),
            Text(
                'Effective Price per Share (with bonuses): \$${effectivePriceWithBonus.toStringAsFixed(2)}'),
            const SizedBox(height: 8.0),
            Text(
                'Total Valuation at Current Price: \$${totalValuation.toStringAsFixed(2)}'),
          ],
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
