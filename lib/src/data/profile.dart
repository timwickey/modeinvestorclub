import 'investor.dart';
import 'deal.dart';

final profileInstance = Profile()
  ..addDeal(
      title: 'Left Hand of Darkness',
      authorName: 'Ursula K. Le Guin',
      isPopular: true,
      isNew: true)
  ..addDeal(
      title: 'Too Like the Lightning',
      authorName: 'Ada Palmer',
      isPopular: false,
      isNew: true)
  ..addDeal(
      title: 'Kindred',
      authorName: 'Octavia E. Butler',
      isPopular: true,
      isNew: false)
  ..addDeal(
      title: 'The Lathe of Heaven',
      authorName: 'Ursula K. Le Guin',
      isPopular: false,
      isNew: false);

class Profile {
  final List<Deal> allDeals = [];
  final List<Author> allAuthors = [];

  void addDeal({
    required String title,
    required String authorName,
    required bool isPopular,
    required bool isNew,
  }) {
    var author = allAuthors.firstWhere(
      (author) => author.name == authorName,
      orElse: () {
        final value = Author(allAuthors.length, authorName);
        allAuthors.add(value);
        return value;
      },
    );
    var book = Deal(allDeals.length, title, isPopular, isNew, author);

    author.books.add(book);
    allDeals.add(book);
  }

  Deal getBook(String id) {
    return allDeals[int.parse(id)];
  }

  List<Deal> get popularBooks => [
        ...allDeals.where((book) => book.isPopular),
      ];

  List<Deal> get newBooks => [
        ...allDeals.where((book) => book.isNew),
      ];
}
