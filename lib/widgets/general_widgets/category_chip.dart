import 'package:flutter/material.dart';

import '../../screens/menu/genre_novels_screen.dart';

class CategoryChip extends StatelessWidget {
  final String label;

  const CategoryChip({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenreNovelsScreen(genre: label),
          ),
        );
      },
      child: Chip(
        label: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}
