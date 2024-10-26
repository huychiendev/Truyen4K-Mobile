import 'package:flutter/material.dart';
import '../../models/library_novel.dart';
import '../novel_widgets/novel_list_item.dart';

class LibraryTab extends StatelessWidget {
  final Future<List<LibraryNovel>> future;
  final Function refreshCallback;
  final String emptyMessage;
  final Function(BuildContext, LibraryNovel) onMoreTap;

  const LibraryTab({
    Key? key,
    required this.future,
    required this.refreshCallback,
    required this.emptyMessage,
    required this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await refreshCallback(),
      child: FutureBuilder<List<LibraryNovel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(emptyMessage));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final novel = snapshot.data![index];
                return NovelListItem(
                  novel: novel,
                  onMoreTap: () => onMoreTap(context, novel),
                );
              },
            );
          }
        },
      ),
    );
  }
}