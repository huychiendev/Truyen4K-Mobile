import 'package:flutter/material.dart';
import 'add_payment_method_screen.dart'; // Import the new screen

class AccountScreen extends StatelessWidget {
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
        title: Text('Tài Khoản', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPaymentMethodScreen()),
              );
            },
            child: Text('Thêm thẻ', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thanh toán',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildPaymentMethod(true, 'Visa', '4322', '07/2022'),
            _buildPaymentMethod(false, '', '1234', '07/2022'),
            _buildPaymentMethod(false, '', '1234', '07/2022'),
            _buildPaymentMethod(false, '', '1234', '07/2022'),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text('Thêm phương thức thanh toán mới'),
              style: ElevatedButton.styleFrom(
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

  Widget _buildPaymentMethod(bool isDefault, String type, String lastDigits, String expiry) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDefault ? Colors.green : Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: TextStyle(color: Colors.white)),
                Text('**** $lastDigits', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Text(expiry, style: TextStyle(color: Colors.white)),
          if (isDefault) Icon(Icons.check_circle, color: Colors.white),
          Icon(Icons.delete, color: Colors.white),
        ],
      ),
    );
  }
}
