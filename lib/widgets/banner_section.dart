import 'package:flutter/material.dart';

class BannerSection extends StatelessWidget {
  final Map<String, dynamic>? bannerData;

  const BannerSection({Key? key, this.bannerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bannerData == null || !bannerData!.containsKey('images')) return SizedBox.shrink();

    // Lấy tối đa 4 hình ảnh từ danh sách
    final images = (bannerData!['images'] as List<dynamic>).take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Đọc full truyện và audio\nkhông giới hạn chỉ với",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "55K",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF7CFC00)),
                ),
                Spacer(),
                Container(
                  width: 240,
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var image in images)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(image, width: 50, height: 90, fit: BoxFit.cover),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              "*Terms & conditions apply",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}