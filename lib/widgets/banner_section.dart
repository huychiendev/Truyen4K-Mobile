import 'package:flutter/material.dart';

class BannerSection extends StatelessWidget {
  final Map<String, dynamic>? bannerData;

  const BannerSection({Key? key, this.bannerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bannerData == null || !bannerData!.containsKey('images')) return SizedBox.shrink();

    // Lấy tối đa 6 hình ảnh từ danh sách
    final images = (bannerData!['images'] as List<dynamic>).take(6).toList();

    // Danh sách kích thước tương ứng cho từng hình ảnh
    final List<Size> imageSizes = [
      Size(60, 85), // Kích thước hình ảnh 1
      Size(60, 85), // Kích thước hình ảnh 2
      Size(60, 85),  // Kích thước hình ảnh 3
      Size(60, 85),  // Kích thước hình ảnh 4
      Size(60, 85),  // Kích thước hình ảnh 5
      Size(60, 85),  // Kích thước hình ảnh 6
    ];

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
                  height: 150, // Tăng chiều cao container để chứa nhiều hình ảnh xếp chồng
                  child: Stack(
                    children: [
                      // Hình ảnh 1
                      Positioned(
                        top: 20,
                        left: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            images[0],
                            width: imageSizes[0].width,
                            height: imageSizes[0].height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Hình ảnh 2
                      Positioned(
                        top: 10,
                        left: 105,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            images[1],
                            width: imageSizes[1].width,
                            height: imageSizes[1].height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Hình ảnh 3
                      Positioned(
                        top: 0,
                        left: 170,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            images[2],
                            width: imageSizes[2].width,
                            height: imageSizes[2].height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Hình ảnh 4
                      Positioned(
                        top: 110,
                        left: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            images[3],
                            width: imageSizes[3].width,
                            height: imageSizes[3].height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Hình ảnh 5
                      Positioned(
                        top: 100,
                        left: 105,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            images[4],
                            width: imageSizes[4].width,
                            height: imageSizes[4].height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Hình ảnh 6
                      Positioned(
                        top: 90,
                        left: 170,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            images[5],
                            width: imageSizes[5].width,
                            height: imageSizes[5].height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              "Điều khoản và điều kiện áp dụng",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
