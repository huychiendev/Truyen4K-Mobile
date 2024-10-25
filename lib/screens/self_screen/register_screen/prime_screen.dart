// // premium/screens/premium_screen.dart
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:apptruyenonline/models/payment_models.dart';
// import 'package:apptruyenonline/services/payment_service.dart';
// import 'package:apptruyenonline/widgets/payment(test)/feature_list.dart';
// import 'package:apptruyenonline/widgets/payment(test)/plan_card.dart';
// import 'package:apptruyenonline/widgets/payment(test)/payment_methods.dart';
//
// class PremiumScreen extends StatefulWidget {
//   @override
//   _PremiumScreenState createState() => _PremiumScreenState();
// }
//
// class _PremiumScreenState extends State<PremiumScreen> {
//   final PaymentService _paymentService = PaymentService();
//   bool isMonthlySelected = true;
//   bool isLoading = false;
//   String? selectedPaymentMethod;
//
//   Future<void> _handlePayment() async {
//     if (selectedPaymentMethod == null) {
//       _showMessage('Vui lòng chọn phương thức thanh toán');
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       final order = PaymentOrder(
//         userId: 'current_user_id', // Get from auth service
//         amount: isMonthlySelected ? 37500 : 450000,
//         title: 'Premium ${isMonthlySelected ? 'Monthly' : 'Yearly'}',
//         description: 'Premium subscription',
//         bankCode: selectedPaymentMethod!,
//         items: [
//           OrderItem(
//             id: isMonthlySelected ? 'premium_monthly' : 'premium_yearly',
//             name: 'Premium Subscription',
//             type: 'subscription',
//             duration: isMonthlySelected ? 30 : 365,
//             price: isMonthlySelected ? 37500 : 450000,
//           )
//         ],
//       );
//
//       final result = await _paymentService.processPayment(order);
//
//       if (result.success) {
//         await _handlePaymentSuccess(result.data!);
//       } else {
//         _showMessage(result.message ?? 'Payment failed');
//       }
//
//     } catch (e) {
//       _showMessage('An error occurred. Please try again.');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _handlePaymentSuccess(PaymentResponse data) async {
//     // Start polling payment status
//     bool isPaid = false;
//     int attempts = 0;
//
//     while (!isPaid && attempts < 30) {
//       final status = await _paymentService.checkPaymentStatus(data.transactionId);
//
//       if (status.isComplete) {
//         isPaid = true;
//         _showSuccessDialog();
//         break;
//       }
//
//       await Future.delayed(Duration(seconds: 2));
//       attempts++;
//     }
//
//     if (!isPaid) {
//       _showMessage('Payment timeout. Please check your payment status.');
//     }
//   }
//
//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: Text('Payment Successful'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.check_circle, color: Colors.green, size: 64),
//             SizedBox(height: 16),
//             Text('Your account has been upgraded to Premium!'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: Text('OK'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               Navigator.of(context).pop(); // Return to previous screen
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message))
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(),
//                 SizedBox(height: 32),
//                 _buildPricingPlans(),
//                 SizedBox(height: 32),
//                 PremiumFeatureList(),
//                 SizedBox(height: 32),
//                 PaymentMethodSelector(
//                   selectedMethod: selectedPaymentMethod,
//                   onSelected: (method) {
//                     setState(() => selectedPaymentMethod = method);
//                   },
//                 ),
//                 SizedBox(height: 32),
//                 _buildPaymentButton(),
//                 SizedBox(height: 16),
//                 _buildCancelButton(),
//                 SizedBox(height: 16),
//                 _buildTerms(),
//               ],
//             ),
//           ),
//           if (isLoading)
//             Container(
//               color: Colors.black54,
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Upgrade to Premium',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           'Enjoy unlimited reading and exclusive features',
//           style: TextStyle(
//             color: Colors.grey[400],
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPricingPlans() {
//     return Row(
//       children: [
//         Expanded(
//           child: PlanCard(
//             title: 'Monthly',
//             price: '37.500đ',
//             features: ['Cancel anytime', 'Full access'],
//             isSelected: isMonthlySelected,
//             onTap: () => setState(() => isMonthlySelected = true),
//           ),
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: PlanCard(
//             title: 'Yearly',
//             price: '450.000đ',
//             features: ['Save 25%', 'Best value'],
//             isSelected: !isMonthlySelected,
//             onTap: () => setState(() => isMonthlySelected = false),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPaymentButton() {
//     return ElevatedButton(
//       onPressed: isLoading ? null : _handlePayment,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.green,
//         minimumSize: Size(double.infinity, 56),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//       ),
//       child: Text(
//         isLoading ? 'Processing...' : 'Upgrade Now',
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCancelButton() {
//     return Center(
//       child: TextButton(
//         onPressed: () => Navigator.pop(context),
//         child: Text(
//           'Not Now',
//           style: TextStyle(color: Colors.grey),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTerms() {
//     return Text(
//       'By continuing, you agree to our Terms of Service and Privacy Policy.',
//       style: TextStyle(
//         color: Colors.grey[600],
//         fontSize: 12,
//       ),
//       textAlign: TextAlign.center,
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../menu/profile_screen.dart';
import 'package:apptruyenonline/screens/self_screen/register_screen/home_page.dart';

class PremiumScreen1 extends StatefulWidget {
  @override
  _PremiumScreen1State createState() => _PremiumScreen1State();
}

class _PremiumScreen1State extends State<PremiumScreen1> {
  bool isMonthlySelected = true;

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
                'Dùng Thử Đọc\nTruyện 247 Premium',
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
                  Expanded(child: _buildPlanCard(true)),
                  SizedBox(width: 10),
                  Expanded(child: _buildPlanCard(false)),
                ],
              ),
              SizedBox(height: 20),
              _buildButton('Bắt đầu dùng thử miễn phí 7 ngày ngay bây giờ'),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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

  Widget _buildPlanCard(bool isMonthly) {
    bool isSelected = isMonthly == isMonthlySelected;
    String price = isMonthly
        ? (isSelected ? '37.500' : '50.000')
        : (isSelected ? '450.000' : '600.000');

    return GestureDetector(
      onTap: () {
        setState(() {
          isMonthlySelected = isMonthly;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
        ),
        child: Column(
          children: [
            Text(
              isMonthly ? 'Hàng Tháng' : 'Hàng Năm',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '$price VND',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              isMonthly
                  ? 'Thanh toán và định kỳ\nhàng tháng\nHủy bất cứ lúc nào'
                  : 'Thanh toán và định kỳ\nhàng năm\nHủy bất cứ lúc nào',
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
      ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to payment screen
        String amount = isMonthlySelected ? '37500' : '450000';
        String planType = isMonthlySelected ? 'Gói Tháng' : 'Gói Năm';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentHomePage(
              paymentAmount: amount,
              planType: planType,
              isMonthly: isMonthlySelected,
            ),
          ),
        );
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}