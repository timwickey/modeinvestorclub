class Deal {
  final int id;
  final String title;
  // make optional
  final String? image;
  final String partnerName;
  final double price;
  final double originalPrice;
  final String url;

  Deal({
    required this.id,
    required this.title,
    this.image, // Make optional
    required this.partnerName,
    required this.price,
    required this.originalPrice,
    required this.url,
  });
}
