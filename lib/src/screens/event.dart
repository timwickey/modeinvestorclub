import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../backend.dart'; // Make sure to adjust the import path as needed
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMd();
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.image != null)
                      Image.network(
                        event.image!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 20.0),
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Partner: ${event.partnerName}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Date: ${dateFormat.format(event.date)}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      event.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Open the event URL
                        _launchInBrowser(Uri.parse(event.url));
                      },
                      child: const Text('Learn More'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
