import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/User.dart';
import '../models/ProfileModel.dart';
import '../screens/authenticator/login_screen.dart';
import 'package:image/image.dart' as img;

class AuthService {
  static const String _baseUrl = 'http://14.225.207.58:9898/api/v1';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // lưu lại username vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<UserProfile?> checkToken(String token) async {
    // lấy ra username từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    final response = await http.get(
      Uri.parse('$_baseUrl/profile/$username'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      return null; // Token expired
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  static Future<void> handleTokenExpiration(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  static Future<List<UserImage>> fetchUserImages(
      String token, int userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/images/?userId=$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => UserImage.fromJson(json)).toList();
    } else if (response.statusCode == 500) {
      throw Exception('Token expired');
    } else {
      throw Exception('Failed to fetch images');
    }
  }

  static Future<void> uploadUserImage(
      String token, int userId, File imageFile) async {
    try {
      // Read the image from file
      img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

      if (image != null) {
        // Resize the image to a smaller size (e.g., 800x800)
        img.Image resizedImage = img.copyResize(image, width: 800);

        // Encode the resized image to a new file
        File compressedImageFile = File('${imageFile.path}_compressed.jpg')
          ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

        final request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://14.225.207.58:9898/api/v1/images/upload?userId=$userId'),
        );
        // request.headers['Authorization'] = 'Bearer $token';
        request.files.add(await http.MultipartFile.fromPath(
            'file', compressedImageFile.path));

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode != 200) {
          print('Server response: $responseBody');
          throw Exception('Failed to upload image');
        } else {
          print('Server response: $responseBody');
        }
      } else {
        throw Exception('Failed to decode image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  static Future<UserImage?> fetchUserDetails(String token, int userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/images/?userId=$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      if (jsonList.isNotEmpty) {
        return UserImage.fromJson(jsonList[0]);
      }
    } else if (response.statusCode == 500) {
      throw Exception('Token expired');
    } else {
      throw Exception('Failed to fetch user details');
    }
    return null;
  }

  // Hàm gửi OTP
  static Future<bool> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Hàm xác minh OTP
  static Future<bool> verifyOtp(
      {required String email, required String otp}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otpCode': otp}),
    );

    if (response.statusCode == 200 && response.body == 'OTP is valid') {
      return true; // OTP đúng
    } else {
      return false; // OTP sai
    }
  }
}
