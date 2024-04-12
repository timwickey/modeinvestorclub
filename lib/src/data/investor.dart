import 'deal.dart';

class Author {
  final int id;
  final String name;
  final books = <Deal>[];

  Author(this.id, this.name);
}
