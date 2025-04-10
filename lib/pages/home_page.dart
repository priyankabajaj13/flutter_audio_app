import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/models/book.dart';
import '../resources/notifiers/audio_books_notifier.dart';
import '../widgets/book_grid_item.dart';
import 'book_details.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  HomePageState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (BuildContext context, AudioBooksNotifier notifier, _){
          if (notifier.books.isEmpty) {
            return const Center(
              child: Text('no posts'),
            );
          }
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              const SliverAppBar(
                title: Text("Books"),
                floating: true,
              ),
              const SliverPadding(
                padding: EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Text("Most Downloaded"),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => BookGridItem(book: notifier.topBooks[index], onTap: () => _openDetail(context, notifier.topBooks[index]),),
                    childCount: notifier.topBooks.length,
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Text("Recent Books"),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => index >= notifier.books.length
                      ? const BottomLoader()
                      : _buildBookItem(context,index,notifier.books),
                    childCount: notifier.hasReachedMax
                      ? notifier.books.length
                      : notifier.books.length + 1,
                  ),
                ),
              ),
            ],
          );
        },
      )
    );
  }


  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      Provider.of<AudioBooksNotifier>(context,listen: false).getBooks();
    }
  }

  Widget _buildBookItem(BuildContext context, int index, List<Book> books) {
    Book book = books[index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(book.title),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(book.image),
          ),
          onTap: () => _openDetail(context,book),
        ),
        const Divider(),
      ],
    );
  }

  void _openDetail(BuildContext context, Book book) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => DetailPage(book)
    ));
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}