import 'package:flutter/material.dart';

class Controls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onNextChapter;
  final VoidCallback onPreviousChapter;

  const Controls({
    Key? key,
    required this.isPlaying,
    required this.onTogglePlayPause,
    required this.onNextChapter,
    required this.onPreviousChapter,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
            onPressed: onPreviousChapter,
          ),
          GestureDetector(
            onTap: onTogglePlayPause,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
            onPressed: onNextChapter,
          ),
        ],
      ),
    );
  }

}