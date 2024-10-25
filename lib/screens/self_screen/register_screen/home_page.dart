import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'payment_config.dart';

class PaymentHomePage extends StatefulWidget {
  final String paymentAmount;
  final String planType;
  final bool isMonthly;

  const PaymentHomePage({
    Key? key,
    required this.paymentAmount,
    required this.planType,
    required this.isMonthly,
  }) : super(key: key);

  @override
  State<PaymentHomePage> createState() => _PaymentHomePageState();
}

class _PaymentHomePageState extends State<PaymentHomePage> {
  late final ApplePayButton applePayButton;
  late final GooglePayButton googlePayButton;

  @override
  void initState() {
    super.initState();
    _initializePaymentButtons();
  }

  void _initializePaymentButtons() {
    // Khởi tạo nút Apple Pay
    applePayButton = ApplePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
      paymentItems: [
        PaymentItem(
          label: 'App Truyện 247 ${widget.planType}',
          amount: widget.paymentAmount,
          status: PaymentItemStatus.final_price,
        ),
      ],
      style: ApplePayButtonStyle.black,
      width: 250, // Giảm chiều rộng xuống
      height: 50, // Tăng chiều cao lên một chút
      type: ApplePayButtonType.buy,
      onPaymentResult: _handlePaymentResult,
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Khởi tạo nút Google Pay
    googlePayButton = GooglePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
      paymentItems: [
        PaymentItem(
          label: 'App Truyện 247 ${widget.planType}',
          amount: widget.paymentAmount,
          status: PaymentItemStatus.final_price,
        ),
      ],
      type: GooglePayButtonType.pay,
      width: 250, // Giảm chiều rộng xuống
      height: 50, // Tăng chiều cao lên một chút
      onPaymentResult: _handlePaymentResult,
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _handlePaymentResult(paymentResult) async {
    try {
      // TODO: Verify payment with backend
      _showPaymentResultDialog(true);
    } catch (e) {
      _showPaymentResultDialog(false);
    }
  }

  void _showPaymentResultDialog(bool success) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? 'Thanh toán thành công' : 'Thanh toán thất bại'),
          content: Text(
            success
                ? 'Cảm ơn bạn đã đăng ký ${widget.planType}. Tài khoản của bạn đã được nâng cấp.'
                : 'Có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                if (success) {
                  // Quay về màn hình chính
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Thanh toán', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xác nhận thanh toán',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildPlanDetails(),
            SizedBox(height: 30),
            Text(
              'Chọn phương thức thanh toán:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 250,  // Match button width
                height: 44,  // Match button height
                child: Platform.isIOS ? applePayButton : googlePayButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetails() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi tiết gói:',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.planType,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Text(
                '${widget.paymentAmount} VND',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            widget.isMonthly
                ? 'Thanh toán hàng tháng'
                : 'Thanh toán hàng năm',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}