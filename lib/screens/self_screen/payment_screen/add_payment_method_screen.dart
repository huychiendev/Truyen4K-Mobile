import 'package:flutter/material.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  @override
  _AddPaymentMethodScreenState createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

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
            _buildInputField('Số thẻ', _cardNumberController),
            SizedBox(height: 10),
            _buildInputField('Tên chủ thẻ', _cardHolderController),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildInputField('CVV', _cvvController)),
                SizedBox(width: 10),
                Expanded(child: _buildInputField('MM/YY', _expiryController)),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _addPaymentMethod,
              child: Text('Thêm phương thức thanh toán'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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

  Widget _buildInputField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
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

  void _addPaymentMethod() {
    if (_cardNumberController.text.isNotEmpty &&
        _cardHolderController.text.isNotEmpty &&
        _cvvController.text.isNotEmpty &&
        _expiryController.text.isNotEmpty) {
      Navigator.pop(context, {
        'cardNumber': _cardNumberController.text,
        'cardHolder': _cardHolderController.text,
        'cvv': _cvvController.text,
        'expiry': _expiryController.text,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin thẻ')),
      );
    }
  }
}