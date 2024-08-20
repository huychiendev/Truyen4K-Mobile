import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter', // Sử dụng font Inter cho toàn bộ ứng dụng
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                image: AssetImage('assets/background.png'), // Đường dẫn tới hình nền
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
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
                        crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh tiêu đề bên trái
                        children: [
                          Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 30),
                          TextField(
                            onTap: () => _showSnackBar(context, 'Bạn vừa click vào ô nhập Email'),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _showSnackBar(context, 'Bạn vừa click vào nút Tiếp tục');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFB2D6A5), // Màu nền nút "Tiếp tục"
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Tiếp tục',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => _showSnackBar(context, 'Bạn vừa click vào Quên mật khẩu?'),
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'Hoặc',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          FractionallySizedBox(
                            widthFactor: 0.9, // Chiếm 90% chiều rộng màn hình
                            child: LoginButton(
                              icon: FontAwesomeIcons.facebookF,
                              text: 'Đăng nhập với Facebook',
                              color: Colors.white,
                              textColor: Colors.blue,
                              onPressed: () {
                                _showSnackBar(context, 'Bạn vừa click vào nút Đăng nhập với Facebook');
                              },
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.9, // Chiếm 90% chiều rộng màn hình
                            child: LoginButton(
                              icon: FontAwesomeIcons.google,
                              text: 'Đăng nhập với Google',
                              color: Colors.white,
                              textColor: Colors.red,
                              onPressed: () {
                                _showSnackBar(context, 'Bạn vừa click vào nút Đăng nhập với Google');
                              },
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.9, // Chiếm 90% chiều rộng màn hình
                            child: LoginButton(
                              icon: FontAwesomeIcons.apple,
                              text: 'Đăng nhập với Apple',
                              color: Colors.white,
                              textColor: Colors.black,
                              onPressed: () {
                                _showSnackBar(context, 'Bạn vừa click vào nút Đăng nhập với Apple');
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: () => _showSnackBar(context, 'Bạn vừa click vào Đăng ký'),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Bạn chưa có tài khoản? ',
                                  style: TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan(
                                      text: 'Đăng ký',
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
}

class LoginButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  LoginButton({
    required this.icon,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        icon: FaIcon(
          icon,
          color: textColor,
        ),
        label: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Màu nền trắng cho nút đăng nhập với các dịch vụ khác
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade300), // Viền mờ
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
