// // premium/services/payment_service.dart
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/payment_models.dart';
//
// class PaymentService {
//   static const String _baseUrl = 'https://payment-zalo-momo.onrender.com';
//
//   Future<PaymentResult> processPayment(PaymentOrder order) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$_baseUrl/payment'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(order.toJson()),
//       );
//
//       if (response.statusCode == 200) {
//         final data = PaymentResponse.fromJson(jsonDecode(response.body));
//         return PaymentResult(success: true, data: data);
//       } else {
//         return PaymentResult(
//           success: false,
//           message: 'Payment failed. Please try again.',
//         );
//       }
//     } catch (e) {
//       return PaymentResult(
//         success: false,
//         message: 'An error occurred. Please try again.',
//       );
//     }
//   }
//
//   Future<PaymentStatus> checkPaymentStatus(String transactionId) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$_baseUrl/check-status-order'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'app_trans_id': transactionId,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         return PaymentStatus.fromJson(jsonDecode(response.body));
//       }
//     } catch (e) {
//       print('Error checking payment status: $e');
//     }
//
//     return PaymentStatus(
//       isComplete: false,
//       status: 'error',
//       message: 'Failed to check payment status',
//     );
//   }
// }