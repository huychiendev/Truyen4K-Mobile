import 'package:flutter/material.dart';

import '../../screens/item_truyen/view_screen/novel_detail_screen.dart';
import '../../models/library_novel.dart';


class NovelListItem extends StatelessWidget {
  final LibraryNovel novel;
  final VoidCallback onMoreTap;

  const NovelListItem({
    Key? key,
    required this.novel,
    required this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(novel.thumbnailImageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        novel.title,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        novel.subtitle,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert, color: Colors.white),
        onPressed: onMoreTap,
      ),
      // Add onTap handler to navigate to NovelDetailScreen
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NovelDetailScreen(slug: novel.slug),
          ),
        );
      },
    );
  }
}