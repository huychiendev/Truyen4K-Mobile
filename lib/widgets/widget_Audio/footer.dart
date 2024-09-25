import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final double playbackSpeed;
  final VoidCallback onChangePlaybackSpeed;

  const Footer({
    Key? key,
    required this.playbackSpeed,
    required this.onChangePlaybackSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.nightlight_round, color: Colors.white, size: 24),
          GestureDetector(
            onTap: onChangePlaybackSpeed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${playbackSpeed.toStringAsFixed(1)}x',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}