import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/ui.dart';
import '../backend.dart';
import '../auth.dart';
import '../data/globals.dart'; // Ensure this import is correct for pageWidth
import 'package:url_launcher/url_launcher.dart'; // Add this import to handle URL launching

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  // Desktop View
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: pageWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                              height: 20.0), // Start 20 pixels from the top
                          Consumer<ModeAuth>(
                            builder: (context, auth, _) {
                              final latestPrice =
                                  auth.user?.getSharePrice() ?? 0.0;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Mode Mobile, INC',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Share price: \$${latestPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20.0),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: InvestmentSummaryCard()),
                              SizedBox(width: 20.0),
                              Expanded(child: TransferOnlineWidget()),
                            ],
                          ),
                          const Divider(thickness: 1.0),
                          const SizedBox(height: 20.0),
                          const InvestmentList(),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Mobile View
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                          height: 20.0), // Start 20 pixels from the top
                      Consumer<ModeAuth>(
                        builder: (context, auth, _) {
                          final latestPrice = auth.user?.getSharePrice() ?? 0.0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mode Mobile, INC',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Share price: \$${latestPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20.0),
                      const InvestmentSummaryCard(),
                      const SizedBox(height: 20.0),
                      const TransferOnlineWidget(),
                      const Divider(thickness: 1.0),
                      const SizedBox(height: 20.0),
                      const InvestmentList(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class InvestmentSummaryCard extends StatelessWidget {
  const InvestmentSummaryCard({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<ModeAuth>(context);
    final user = auth.user;
    if (user == null) return Container();

    final totalShares = user.calculateTotalShares();
    final totalValuation = user.getPortfolioValue();
    final totalCost = user.getCost();
    final bonusShares = user.getBonusShares();
    final pricePerShareWithBonus = user.getPricePerShareWithBonus();
    final pricePerShareWithoutBonus = user.getPricePerShareWithoutBonus();
    final gain = user.getGain();
    final gainPercentage = (totalCost > 0) ? (gain / totalCost) * 100 : 0.0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: borderColor,
          width: borderThickness,
        ),
      ),
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
            Text('Total Shares with Bonus: ${totalShares + bonusShares}'),
            const SizedBox(height: 8.0),
            Text(
                'Effective Price per Share (without bonuses): \$${pricePerShareWithoutBonus.toStringAsFixed(2)}'),
            Text(
                'Effective Price per Share (with bonuses): \$${pricePerShareWithBonus.toStringAsFixed(2)}'),
            const SizedBox(height: 8.0),
            Text(
                'Total Valuation at Current Price: \$${totalValuation.toStringAsFixed(2)}'),
            Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
            Text('Gain: \$${gain.toStringAsFixed(2)}'),
            Row(
              children: [
                const Text('Percentage Gain: '),
                Text(
                  '${gainPercentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: gainPercentage >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  gainPercentage >= 0
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: gainPercentage >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

class TransferOnlineWidget extends StatelessWidget {
  const TransferOnlineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<ModeAuth>(context);
    final user = auth.user;

    if (user == null) {
      return Container();
    }

    final String shareholderId = user.toShareholderId;
    final String accessCode = user.toAccessCode;
    final bool isRegistered = user.toRegistered;
    final String buttonText = isRegistered ? 'View Shares' : 'Register';
    final String url = isRegistered ? user.toRegisterUrl : user.toUrl;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: borderColor,
          width: borderThickness,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your custodian is Transfer Online. They hold your shares.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Shareholder ID: $shareholderId'),
            Text('Access Code: $accessCode'),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.center,
              child: RoundedButton(
                  text: buttonText,
                  color: transparentButton,
                  icon: Icon(Icons.work),
                  onPressed: () {
                    _launchInBrowser(Uri.parse(url));
                  }),
            ),
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
      children: [
        const Text(
          'Your Investments',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20.0),
        ...investments.map((investment) => InvestmentCard(investment)),
      ],
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
            Text('Date Purchased: ${dateFormat.format(investment.date)}'),
          ],
        ),
      ),
    );
  }
}
