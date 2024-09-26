import 'package:flutter/material.dart';
import '../../../item_truyen/view_screen/novel_detail_screen.dart';
import '../models/library_novel.dart';

class NovelListItem extends StatelessWidget {
  final LibraryNovel novel;

  const NovelListItem({Key? key, required this.novel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 70,
        color: Colors.grey[300],
        child: Image.network(novel.thumbnailImageUrl, fit: BoxFit.cover),
      ),
      title: Text(
        novel.title,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        novel.subtitle,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(novel.trailingIcon),
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