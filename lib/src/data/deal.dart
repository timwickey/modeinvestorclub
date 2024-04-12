import 'investor.dart';

class Deal {
  final int id;
  final String title;
  final Author author;
  final bool isPopular;
  final bool isNew;

  Deal(this.id, this.title, this.isPopular, this.isNew, this.author);
}
