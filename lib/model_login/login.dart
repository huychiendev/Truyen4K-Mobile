import 'dart:ui';
import 'package:apptruyenonline/main.dart';
import 'package:apptruyenonline/model_login/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'forgot_password.dart'; // Import MainScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

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
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            onTap: () => _showSnackBar(
                                context, 'Bạn vừa click vào ô nhập Email'),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            onTap: () => _showSnackBar(
                                context, 'Bạn vừa click vào password'),
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 18,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MainScreen()), // Chuyển hướng đến MainScreen
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xBD8DDA61),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Tiếp tục',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  color: Colors.lightGreenAccent,
                                  decoration: TextDecoration.none,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                child: Text(
                                  'Hoặc',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
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
                            widthFactor: 1,
                            child: LoginButton(
                              icon: FontAwesomeIcons.facebookF,
                              text: 'Đăng nhập với Facebook',
                              color: Colors.white,
                              textColor: Colors.blue,
                              onPressed: () {
                                _showSnackBar(context,
                                    'Bạn vừa click vào nút Đăng nhập với Facebook');
                              },
                              fontSize: 14,
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: LoginButton(
                              icon: FontAwesomeIcons.google,
                              text: 'Đăng nhập với Google',
                              color: Colors.white,
                              textColor: Colors.red,
                              onPressed: () {
                                _showSnackBar(context,
                                    'Bạn vừa click vào nút Đăng nhập với Google');
                              },
                              fontSize: 14,
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: LoginButton(
                              icon: FontAwesomeIcons.apple,
                              text: 'Đăng nhập với Apple',
                              color: Colors.white,
                              textColor: Colors.black,
                              onPressed: () {
                                _showSnackBar(context,
                                    'Bạn vừa click vào nút Đăng nhập với Apple');
                              },
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 25),
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
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: 'Đăng ký',
                                      style: TextStyle(
                                        color: Colors.lightGreenAccent,
                                        decoration: TextDecoration.none,
                                        fontSize: 14,
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
  final double fontSize;

  LoginButton({
    required this.icon,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onPressed,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onPressed: onPressed,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0), // Điều chỉnh khoảng cách icon
                child: FaIcon(
                  icon,
                  color: textColor,
                  size: fontSize + 4,
                ),
              ),
            ),
            Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold, // Đặt fontWeight về bình thường
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}