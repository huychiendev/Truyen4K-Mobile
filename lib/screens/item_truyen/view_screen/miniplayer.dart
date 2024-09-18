import 'package:flutter/material.dart';

class MiniPlayer extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final bool isPlaying;

  const MiniPlayer({
    Key? key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.onTap,
    required this.onPlayPause,
    required this.onNext,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        color: Color(0xFF282828),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.music_note, color: Colors.white);
                },
              )
                  : Icon(Icons.music_note, color: Colors.white),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      artist,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: onPlayPause,
            ),
            IconButton(
              icon: Icon(Icons.skip_next, color: Colors.white),
              onPressed: onNext,
            ),
          ],
        ),
      ),
    );
  }
}