import 'package:flutter/material.dart';
import 'package:modeinvestorclub/src/widgets/ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../backend.dart';
import '../data/globals.dart';

class DealList extends StatelessWidget {
  final List<Deal> deals;
  final ValueChanged<Deal>? onTap;

  const DealList({
    required this.deals,
    this.onTap,
    super.key,
  });

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
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
                      spacing: dealSpacing,
                      runSpacing: dealSpacing,
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
                            width: dealWidth, // Set the width of each card
                            height:
                                dealHeight, // Set the height of the container
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
                                const Divider(
                                    thickness: borderThickness,
                                    color: borderColor),
                                const SizedBox(height: 12),
                                FreeDealWidget(
                                  originalPrice: deal.originalPrice,
                                  price: deal.price,
                                ),
                                Spacer(),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: RoundedButton(
                                        text: "CLAIM PERK",
                                        color: transparentButton,
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          _launchInBrowser(Uri.parse(deal.url));
                                        })),
                                const SizedBox(height: 12),
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
                child: (deal.image != null && deal.image!.isNotEmpty)
                    ? (deal.image!.endsWith('.svg')
                        ? SvgPicture.network(
                            deal.image!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholderBuilder: (BuildContext context) =>
                                const Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.blue,
                            ),
                          )
                        : Image.network(
                            deal.image!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.blue,
                              );
                            },
                          ))
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

class FreeDealWidget extends StatelessWidget {
  final double originalPrice;
  final double price;

  const FreeDealWidget({
    required this.originalPrice,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String pricetext = "FREE";

    if (price > 0) {
      pricetext = '\$${price.toStringAsFixed(2)}';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient 'FREE' Text
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: const [leftGradient, rightGradient],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            pricetext,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8), // Space between the texts
        // Original Price with a Slash Mark Through It, offset upwards
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '\$$originalPrice',
                style: const TextStyle(
                  fontSize: 20, // Slightly smaller font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: DiagonalStrikethroughPainter(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DiagonalStrikethroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = leftGradient
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
