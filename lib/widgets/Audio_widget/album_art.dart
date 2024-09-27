import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumArt extends StatelessWidget {
  final String thumbnailImageUrl;

  const AlbumArt({
    Key? key,
    required this.thumbnailImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(8),
        ),
        child: CachedNetworkImage(
          imageUrl: thumbnailImageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) =>
              Icon(Icons.image_not_supported, size: 64, color: Colors.white),
        ),
      ),
    );
  }
}