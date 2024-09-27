import 'package:flutter/material.dart';
import 'dart:math';

class ChapterList extends StatefulWidget {
  final int totalChapters;
  final Function(int) onChapterTap;

  const ChapterList({
    Key? key,
    required this.totalChapters,
    required this.onChapterTap,
  }) : super(key: key);

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  bool _showAllChapters = false;

  @override
  Widget build(BuildContext context) {
    int chaptersToShow = _showAllChapters ? widget.totalChapters : min(5, widget.totalChapters);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Danh sách chương',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: chaptersToShow,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                'Chương ${index + 1}',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.play_arrow, color: Colors.white),
              onTap: () => widget.onChapterTap(index + 1),
            );
          },
        ),
        if (widget.totalChapters > 5 && !_showAllChapters)
          Center(
            child: ElevatedButton(
              child: Text('Xem thêm'),
              onPressed: () {
                setState(() {
                  _showAllChapters = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF232538),
              ),
            ),
          ),
      ],
    );
  }
}