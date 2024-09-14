// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class PaymentMethodService {
//   static const String _key = 'payment_methods';
//
//   static Future<List<Map<String, String>>> getPaymentMethods() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? paymentMethodsJson = prefs.getString(_key);
//     if (paymentMethodsJson != null) {
//       final List<dynamic> decodedList = json.decode(paymentMethodsJson);
//       return decodedList.cast<Map<String, String>>();
//     }
//     return [];
//   }
//
//   static Future<void> savePaymentMethods(List<Map<String, String>> paymentMethods) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String encodedList = json.encode(paymentMethods);
//     await prefs.setString(_key, encodedList);
//   }
//
//   static Future<void> addPaymentMethod(Map<String, String> paymentMethod) async {
//     final paymentMethods = await getPaymentMethods();
//     paymentMethods.add(paymentMethod);
//     await savePaymentMethods(paymentMethods);
//   }
//
//   static Future<void> deletePaymentMethod(String lastDigits) async {
//     final paymentMethods = await getPaymentMethods();
//     paymentMethods.removeWhere((method) => method['lastDigits'] == lastDigits);
//     await savePaymentMethods(paymentMethods);
//   }
// }