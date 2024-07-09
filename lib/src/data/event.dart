class Event {
  final int id;
  final String title;
  // make optional
  final String? image;
  final String partnerName;
  final DateTime date;
  final DateTime time;
  final String description;
  final String url;

  Event({
    required this.id,
    required this.title,
    this.image, // Make optional
    required this.partnerName,
    required this.date,
    required this.time,
    required this.description,
    required this.url,
  });
}
