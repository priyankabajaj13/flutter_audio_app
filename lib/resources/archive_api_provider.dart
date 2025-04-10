import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:pb_audio_books/resources/repository.dart';

import 'models/audiofile.dart';
import 'models/book.dart';

const _metadata = "https://archive.org/metadata/";
const _commonParams = "q=collection:(librivoxaudio)&fl=runtime,avg_rating,num_reviews,title,description,identifier,creator,date,downloads,subject,item_size";

const _latestBooksApi = "https://archive.org/advancedsearch.php?$_commonParams&sort[]=addeddate desc&output=json";

const _mostDownloaded = "https://archive.org/advancedsearch.php?$_commonParams&sort[]=downloads desc&rows=10&page=1&output=json";
  const query="title:(secret tomb) AND collection:(librivoxaudio)";

class ArchiveApiProvider implements Source{

  Client client = Client();

  @override
  Future<List<Book>> fetchBooks(int offset, int limit) async {
    final response = await client.get(Uri.parse("$_latestBooksApi&rows=$limit&page=${offset/limit + 1}"));
    Map resJson = json.decode(response.body);
    return Book.fromJsonArray(resJson['response']['docs']);
  }

  @override
  Future<List<AudioFile>> fetchAudioFiles(String? bookId) async {
    final response = await client.get(Uri.parse("$_metadata/$bookId/files"));
    Map resJson = json.decode(response.body);
    List<AudioFile> afiles = [];
    resJson["result"].forEach((item) {
      if(item["source"] == "original" &&item["track"] != null) {
        item["book_id"] = bookId;
          afiles.add(AudioFile.fromJson(item));
      }
    });
    return afiles;
  }

  @override
  Future<List<Book>> topBooks() async {
    final response = await client.get(Uri.parse(_mostDownloaded));
    Map resJson = json.decode(response.body);
    return Book.fromJsonArray(resJson['response']['docs']);
  }

}

final archiveApiProvider = ArchiveApiProvider();