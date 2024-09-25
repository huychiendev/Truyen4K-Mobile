import 'package:flutter/material.dart';

class BannerSection extends StatefulWidget {
  final Map<String, dynamic>? bannerData;

  const BannerSection({Key? key, this.bannerData}) : super(key: key);

  @override
  _BannerSectionState createState() => _BannerSectionState();
}
class _BannerSectionState extends State<BannerSection> {
  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ContentBox(context),
        );
      },
    );
  }

  Widget ContentBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF8BC34A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Text(
              "Điều khoản và Điều kiện",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6, // Giới hạn chiều cao tối đa
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Chào mừng bạn đến với ứng dụng nghe truyện audio (sau đây gọi là 'Ứng Dụng'). "
                      "Việc bạn sử dụng Ứng Dụng đồng nghĩa với việc bạn đồng ý tuân thủ các điều khoản và điều kiện dưới đây.\n\n"

                      "2. Quyền sử dụng\n"
                      "Bạn được cấp quyền sử dụng Ứng Dụng cho mục đích cá nhân, không thương mại.\n"
                      "Bạn không được phép sao chép, sửa đổi, phân phối hay phát tán nội dung trong Ứng Dụng mà không có sự đồng ý của chúng tôi.\n\n"

                      "3. Trách nhiệm của người dùng\n"
                      "Bạn cam kết cung cấp thông tin chính xác và đầy đủ khi đăng ký tài khoản.\n"
                      "Bạn chịu trách nhiệm về mọi hoạt động diễn ra trên tài khoản của mình.\n\n"

                      "4. Bảo mật thông tin\n"
                      "Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn theo quy định của pháp luật.\n"
                      "Bạn có trách nhiệm bảo mật thông tin đăng nhập của mình.\n\n"

                      "5. Quyền sở hữu trí tuệ\n"
                      "Tất cả nội dung trong Ứng Dụng (bao gồm nhưng không giới hạn ở văn bản, âm thanh, hình ảnh) đều thuộc quyền sở hữu của chúng tôi hoặc bên thứ ba có liên quan.\n\n"

                      "6. Thay đổi điều khoản\n"
                      "Chúng tôi có quyền thay đổi các điều khoản và điều kiện này mà không cần thông báo trước. Bạn nên thường xuyên kiểm tra để cập nhật thông tin.\n\n"

                      "7. Liên hệ\n"
                      "Nếu bạn có bất kỳ câu hỏi nào về các điều khoản và điều kiện này, vui lòng liên hệ với chúng tôi qua địa chỉ email hoặc số điện thoại được cung cấp trong Ứng Dụng.",

                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16, right: 16),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Đóng",
                  style: TextStyle(fontSize: 16, color: Color(0xFF8BC34A)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (widget.bannerData == null || !widget.bannerData!.containsKey('images')) return SizedBox.shrink();

    // Lấy tối đa 6 hình ảnh từ danh sách
    final images = (widget.bannerData!['images'] as List<dynamic>).take(6).toList();

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
                          borderRadius: BorderRadius.circular(1),
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
            TextButton(
              onPressed: () => _showTermsAndConditions(context),
              child: Text(
                "Điều khoản và điều kiện áp dụng",
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
