import 'package:apptruyenonline/screens/menu/profile_screen.dart';
import 'package:flutter/material.dart';

class PremiumScreen1 extends StatelessWidget {
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
                'Thông tin chi tiết không giới hạn từ Truyện,\n'
                    'tài liệu về các truyện mới cập nhật',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tất cả các gói cao cấp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildPlanCard(false)),
                  SizedBox(width: 10),
                  Expanded(child: _buildPlanCard(true)),
                ],
              ),
              SizedBox(height: 20),
              _buildButton('Bắt đầu dùng thử miễn phí 7 ngày ngay bây giờ'),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: Text(
                    'KHÔNG, CẢM ƠN',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
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

  Widget _buildPlanCard(bool isSelected) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
        border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
      ),
      child: Column(
        children: [
          Text(
            'Hàng Tháng',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            isSelected ? '37.500 VND' : '50.000 VND',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Thanh toán và định kỳ\nhàng tháng\nHủy bất cứ lúc nào',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
            textAlign: TextAlign.center,
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Tiết kiệm 75%',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(text),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
