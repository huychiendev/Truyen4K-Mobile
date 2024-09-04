import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DataService {
  static Future<Map<String, dynamic>> loadData() async {
    final jsonString = await rootBundle.loadString('assets/mock_data.json');
    return json.decode(jsonString) as Map<String, dynamic>;
  }
}