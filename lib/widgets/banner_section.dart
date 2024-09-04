import 'package:flutter/material.dart';

class BannerSection extends StatelessWidget {
  final Map<String, dynamic>? bannerData;

  const BannerSection({Key? key, this.bannerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bannerData == null) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF323860),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Đọc full truyện và audio\nkhông giới hạn chỉ với",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "55K",
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
                ),
                Spacer(),
                Container(
                  width: 180,
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBookStack(bannerData!['images'][0], bannerData!['images'][1], 0.8),
                      _buildBookStack(bannerData!['images'][2], bannerData!['images'][3], 0.9),
                      _buildBookStack(bannerData!['images'][4], bannerData!['images'][5], 1.0),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "*Terms & conditions apply",
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookStack(String topImageUrl, String bottomImageUrl, double scaleFactor) {
    return Container(
      width: 55 * scaleFactor,
      height: 120 * scaleFactor,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildBookCover(bottomImageUrl, 50 * scaleFactor, 75 * scaleFactor),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _buildBookCover(topImageUrl, 50 * scaleFactor, 75 * scaleFactor),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCover(String imageUrl, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}