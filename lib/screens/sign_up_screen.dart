import 'dart:convert';
import 'dart:ui'; // Để sử dụng ImageFilter
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_text_field_sign_up.dart';
import '../widgets/dialogs.dart';
import '../screens/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    final url = Uri.parse('http://14.225.207.58:9898/api/v1/save');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
        'email': _emailController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      showSuccessDialog(context, 'Đăng ký thành công! ID: ${data['id']}');
    } else {
      showErrorDialog(context, 'Đăng ký thất bại. Vui lòng thử lại.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            'Đăng ký',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Có vẻ như bạn chưa có tài khoản, hãy tạo một tài khoản mới cho bạn.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            label: 'Tên',
                            hint: 'Nhập tên của bạn',
                            controller: _usernameController,
                          ),
                          SizedBox(height: 15),
                          CustomTextField(
                            label: 'Email',
                            hint: 'Nhập email của bạn',
                            controller: _emailController,
                          ),
                          SizedBox(height: 15),
                          CustomTextField(
                            label: 'Mật khẩu',
                            hint: 'Nhập mật khẩu của bạn',
                            controller: _passwordController,
                            obscureText: true,
                          ),
                          SizedBox(height: 15),
                          CustomTextField(
                            label: 'Xác nhận mật khẩu',
                            hint: 'Nhập lại mật khẩu của bạn',
                            controller: _confirmPasswordController,
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          Text.rich(
                            TextSpan(
                              text: 'Bằng cách chọn Tạo tài khoản bên dưới, tôi đồng ý với',
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: ' Điều khoản dịch vụ và chính sách bảo mật',
                                  style: TextStyle(
                                    color: Colors.lightGreenAccent,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _register(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8CD860),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Tạo Tài Khoản',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Text.rich(
                                TextSpan(
                                  text: 'Bạn đã có tài khoản? ',
                                  style: TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan(
                                      text: 'Đăng nhập',
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
}