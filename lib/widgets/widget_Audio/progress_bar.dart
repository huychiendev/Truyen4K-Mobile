import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final double totalDuration;
  final ValueChanged<double> onChanged;

  const ProgressBar({
    Key? key,
    required this.progress,
    required this.totalDuration,
    required this.onChanged,
  }) : super(key: key);

  String _formatDuration(double seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds.toInt() % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.grey[700],
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(progress * totalDuration),
                  style: TextStyle(color: Colors.white, fontSize: 12)),
              Text(_formatDuration(totalDuration),
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}