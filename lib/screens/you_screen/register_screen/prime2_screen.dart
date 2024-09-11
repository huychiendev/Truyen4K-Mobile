import 'package:flutter/material.dart';

class PremiumScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dụng Thử Đọc\nTruyện 247 Premium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Thông tin chi tiết không giới hạn từ Truyện,\ntài liệu về các truyện mới cập nhật',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Ưu đãi có hạn ngay hôm nay',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildFeatureTable(),
              SizedBox(height: 20),
              _buildButton('Bắt đầu dùng thử miễn phí 3 ngày ngay bây giờ'),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'chỉ với 550.000 VND / Year',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'XEM TẤT CẢ CÁC KẾ HOẠCH',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Tư cách thành viên của bạn bắt đầu ngay khi bạn thiết lập thanh toán và đăng ký. Khoản phí hàng tháng của bạn sẽ được tính vào ngày cuối cùng của kỳ thanh toán hiện tại. Chúng tôi sẽ gia hạn tư cách thành viên của bạn để bạn có thể quản lý đăng ký của mình hoặc tắt tính năng tự động gia hạn trong cài đặt tài khoản.',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              SizedBox(height: 10),
              Text(
                'Bằng cách tiếp tục, bạn đồng ý với các điều khoản này. Xem tuyên bố về quyền riêng tư và các hạn chế.',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildFeatureRow('Những gì bạn nhận được', 'Miễn Phí', 'Cao Cấp'),
          _buildFeatureRow('Không Quảng Cáo', false, true),
          _buildFeatureRow('Nội Dung Độc Được Cá Nhân Hóa', false, true),
          _buildFeatureRow('Huy Hiệu Đặc Biệt', false, true),
          _buildFeatureRow('Đọc Không Giới Hạn', false, true),
          _buildFeatureRow('Tích Điểm Vip', false, '1/tháng'),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature, dynamic freeValue, dynamic premiumValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(feature, style: TextStyle(color: Colors.white)),
          ),
          Expanded(
            child: _buildValueWidget(freeValue),
          ),
          Expanded(
            child: _buildValueWidget(premiumValue),
          ),
        ],
      ),
    );
  }

  Widget _buildValueWidget(dynamic value) {
    if (value is bool) {
      return Icon(
        value ? Icons.check : Icons.close,
        color: value ? Colors.green : Colors.red,
      );
    } else {
      return Text(
        value.toString(),
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(text),
      style: ElevatedButton.styleFrom(
        //primary: Colors.green,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}