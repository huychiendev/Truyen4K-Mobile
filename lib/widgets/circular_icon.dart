import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  final String label;

  const CircularIcon({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.book, color: Colors.white),
          ),
          SizedBox(height: 8),
          Container(
            width: 60,
            child: Text(
              label,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}