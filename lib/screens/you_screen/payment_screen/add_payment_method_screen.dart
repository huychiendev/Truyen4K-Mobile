import 'package:flutter/material.dart';

class AddPaymentMethodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Thanh toán', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thêm phương thức thanh toán',
              style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Thông tin chi tiết không giới hạn từ sách, tài liệu và khóa học và podcast.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            _buildInputField('Số thẻ'),
            SizedBox(height: 10),
            _buildInputField('Tên chủ thẻ'),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildInputField('CVV')),
                SizedBox(width: 10),
                Expanded(child: _buildInputField('MM/YY')),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text('Thêm phương thức thanh toán'),
              style: ElevatedButton.styleFrom(
                //primary: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}