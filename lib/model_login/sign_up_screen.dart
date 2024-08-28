import 'package:apptruyenonline/model_login/main.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Để sử dụng ImageFilter

class SignUpScreen extends StatelessWidget {
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
                        color: Colors.white.withOpacity(0.3),
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 20),
                          _buildTextField('Tên', 'Nhập tên của bạn'),
                          SizedBox(height: 15),
                          _buildTextField('Email', 'Nhập email của bạn'),
                          SizedBox(height: 15),
                          _buildTextField('Mật khẩu', 'Nhập mật khẩu của bạn', obscureText: true),
                          SizedBox(height: 15),
                          _buildTextField('Xác nhận mật khẩu', 'Nhập lại mật khẩu của bạn', obscureText: true),
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
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              // Thực hiện đăng ký ở đây
                            },
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
                                        decoration: TextDecoration.underline,
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

  Widget _buildTextField(String label, String hint, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
