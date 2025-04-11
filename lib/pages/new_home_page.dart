import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pb_audio_books/resources/models/book.dart';

import '../data_provider.dart';
import '../widgets/book_grid_item.dart';
import 'book_details.dart';
import 'home_page.dart';

class NewHomePage extends ConsumerStatefulWidget{
  const NewHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return NewHomePageState();
  }
}
class NewHomePageState extends ConsumerState {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  NewHomePageState(){
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller:  _scrollController,
        slivers: [
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
          GetMostDownloadedBooks(),
          const SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Text("Recent Books"),
            ),
          ),
          GetRecentBooks()
        ],
      ),
    );
  }
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      ref.watch(topBooksProvider);
    }
  }

}
class GetMostDownloadedBooks extends ConsumerWidget{
  const GetMostDownloadedBooks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topBooksData = ref.watch(topBooksProvider);
    List<Book> mostbooks = topBooksData.value??[];
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => BookGridItem(book: mostbooks[index],
            onTap: () => openDetail(context, mostbooks[index]),),
          childCount: mostbooks.length,
        ),
      ),
    );
  }

}
class GetRecentBooks extends ConsumerWidget{
  const GetRecentBooks({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final recentBooksData = ref.watch(recentBooksProvider);
    List<Book> recentBooks = recentBooksData.value??[];
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
                (context, index) => index >= recentBooks.length
                ? const BottomLoader()
                : buildBookItem(context,index,recentBooks),
            childCount: recentBooks.length

        ),
      ),
    );

  }

}
void openDetail(BuildContext context, Book book) {
  Navigator.push(context, MaterialPageRoute(
      builder: (_) => DetailPage(book)
  ));
}
Widget buildBookItem(BuildContext context, int index, List<Book> books) {
  Book book = books[index];
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ListTile(
        title: Text(book.title),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(book.image),
        ),
        onTap: () => openDetail(context,book),
      ),
      const Divider(),
    ],
  );
}

