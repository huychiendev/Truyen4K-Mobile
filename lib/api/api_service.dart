import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<Map<String, String>> getAuthHeaders({bool requiresAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) throw Exception('No authentication token found');
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Future<dynamic> get(String url, {
    Map<String, String>? headers,
    bool requiresAuth = true,
    Duration timeout = const Duration(seconds: 30)
  }) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers ?? await getAuthHeaders(requiresAuth: requiresAuth),
      ).timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<dynamic> post(String url, dynamic body, {
    Map<String, String>? headers,
    bool requiresAuth = true
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers ?? await getAuthHeaders(requiresAuth: requiresAuth),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<dynamic> put(String url, dynamic body, {
    Map<String, String>? headers,
    bool requiresAuth = true
  }) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers ?? await getAuthHeaders(requiresAuth: requiresAuth),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<dynamic> delete(String url, {
    Map<String, String>? headers,
    bool requiresAuth = true
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers ?? await getAuthHeaders(requiresAuth: requiresAuth),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    }

    throw HttpException('API Error: ${response.statusCode} - ${response.body}');
  }

  static Exception _handleError(dynamic error) {
    print('API Error: $error');
    return Exception('Something went wrong. Please try again later.');
  }
}