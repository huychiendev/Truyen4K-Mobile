import 'package:flutter/material.dart';
import '../models/novel.dart';
import 'novel_card.dart';

class HorizontalNovelList extends StatelessWidget {
  final List<Novel> novels;
  final Function(Novel) onNovelTap;
  final Function(Novel) onPlayTap;

  const HorizontalNovelList({
    Key? key,
    required this.novels,
    required this.onNovelTap,
    required this.onPlayTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: novels.length,
        itemBuilder: (context, index) {
          return NovelCard(
            novel: novels[index],
            onTap: () => onNovelTap(novels[index]),
            onPlayTap: () => onPlayTap(novels[index]),
          );
        },
      ),
    );
  }
}