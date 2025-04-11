import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pb_audio_books/resources/archive_api_provider.dart';
import 'package:pb_audio_books/resources/models/book.dart';

final topBooksProvider = FutureProvider<List<Book>>((ref) async {
  return ref.watch(dataProvider).topBooks();
});
final recentBooksProvider = FutureProvider<List<Book>>((ref) async {
  return ref.watch(dataProvider).fetchBooks(10, 20);
});

