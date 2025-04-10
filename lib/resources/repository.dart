import 'dart:async';

import './models/models.dart';
import 'archive_api_provider.dart';
import 'books_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    archiveApiProvider,
  ];

  List<Cache> caches = <Cache>[
    DatabaseHelper()
  ];

  Future<List<Book>> fetchBooks(int offset, int limit) async {
    List<Book> books;
    books = await caches[0].getBooks(offset, limit);
    if(books.isEmpty){
      books = await sources[0].fetchBooks(offset,limit);
      caches[0].saveBooks(books);
    }
    return books;
  }
  Future<List<Book>> topBooks() async {
    List<Book> books;
    books = await sources[0].topBooks();
    return books;
  }

  Future<List<AudioFile>> fetchAudioFiles(String? bookId) async {
    List<AudioFile> audiofiles;
    audiofiles = await caches[0].fetchAudioFiles(bookId);
    if(audiofiles.isEmpty ) {
      audiofiles = await sources[0].fetchAudioFiles(bookId);
      caches[0].saveAudioFiles(audiofiles);
    }
    return audiofiles;
  }

}

abstract class Source {
  Future<List<Book>> fetchBooks(int offset, int limit);
  Future<List<Book>> topBooks();
  Future<List<AudioFile>> fetchAudioFiles(String? bookId);
}

abstract class Cache{
  Future saveBooks(List<Book> books);
  Future saveAudioFiles(List<AudioFile> audiofiles);
  Future<List<Book>> getBooks(int offset, int limit);
  Future<List<AudioFile>> fetchAudioFiles(String? bookId);
}