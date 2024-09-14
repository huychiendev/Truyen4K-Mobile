import 'package:flutter/material.dart';
import 'add_payment_method_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<Map<String, String>> paymentMethods = [
    {'type': 'Visa', 'lastDigits': '4322', 'expiry': '07/2022'},
  ];

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
            onPressed: _addNewPaymentMethod,
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
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  return _buildPaymentMethod(
                    index == 0,
                    paymentMethods[index]['type'] ?? '',
                    paymentMethods[index]['lastDigits'] ?? '',
                    paymentMethods[index]['expiry'] ?? '',
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addNewPaymentMethod,
              child: Text(
                'Thêm phương thức thanh toán mới',
                style: TextStyle(color: Colors.white),
              ),
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
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () => _deletePaymentMethod(lastDigits),
          ),
        ],
      ),
    );
  }

  void _addNewPaymentMethod() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentMethodScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        paymentMethods.add({
          'type': _getCardType(result['cardNumber'] ?? ''),
          'lastDigits': result['cardNumber']!.substring(result['cardNumber']!.length - 4),
          'expiry': result['expiry'] ?? '',
        });
      });
    }
  }

  void _deletePaymentMethod(String lastDigits) {
    setState(() {
      paymentMethods.removeWhere((method) => method['lastDigits'] == lastDigits);
    });
  }

  String _getCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) {
      return 'Visa';
    } else if (cardNumber.startsWith('5')) {
      return 'MasterCard';
    } else {
      return 'Card';
    }
  }
}