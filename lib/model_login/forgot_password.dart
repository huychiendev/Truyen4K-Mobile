import 'dart:convert';
import 'dart:ui'; // Để sử dụng ImageFilter
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'reset_password.dart';
import 'sign_up_screen.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  Future<void> _sendOtp(BuildContext context) async {
    final url = Uri.parse('http://14.225.207.58:9898/api/v1/forgot-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _emailController.text}),
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      print('đây là kq'+ responseBody);  // Thêm log để xem chi tiết phản hồi từ server
      try {
        final data = jsonDecode(responseBody);
        if (data is Map && data['status'] == 'INTERNAL_SERVER_ERROR') {
          _showDialog(context, 'Lỗi', 'Tài khoản không tồn tại.');
        } else {
          _showDialog(context, 'Lỗi', data['message'] ?? 'Đã xảy ra lỗi. Vui lòng thử lại.');
        }
      } catch (e) {
        if (responseBody.contains('OTP has been sent to your email.')) {
          _showDialog(context, 'Thông báo', 'OTP đã được gửi đến email của bạn.');
        } else {
          _showDialog(context, 'Lỗi', 'Đã xảy ra lỗi. Vui lòng thử lại.');
        }
      }
    } else {
      print('Error: ${response.statusCode} - ${response.body}');  // In log lỗi nếu mã trạng thái không phải là 200
      _showDialog(context, 'Lỗi', 'Đã xảy ra lỗi. Vui lòng thử lại.');
    }

  }

  Future<void> _verifyOtp(BuildContext context) async {
    final url = Uri.parse('http://14.225.207.58:9898/api/v1/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
        'otpCode': _otpController.text,
      }),
    );

    if (response.statusCode == 200 && response.body == 'OTP is valid') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPassword(email: _emailController.text),
        ),
      );
    } else {
      _showDialog(context, 'Lỗi', 'OTP không hợp lệ.');
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quay lại đăng nhập"),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khôi Phục Mật Khẩu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Bạn quên mật khẩu? Đừng lo lắng, hãy nhập email của bạn để đặt lại mật khẩu hiện tại.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTextField('Email', 'Nhập email của bạn', _emailController),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField('Mã OTP', 'Nhập mã OTP của bạn', _otpController),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => _sendOtp(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF8CD860),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Gửi',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _verifyOtp(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8CD860),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Xác nhận',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                              },
                              child: Text.rich(
                                TextSpan(
                                  text: 'Bạn chưa có tài khoản? ',
                                  style: TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan(
                                      text: 'Đăng Ký',
                                      style: TextStyle(
                                        color: Colors.lightGreenAccent,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
    );
  }
}