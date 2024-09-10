import 'package:apptruyenonline/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/login_constants.dart';
//import '../model_login/forgot_password.dart';
//import '../model_login/sign_up_screen.dart';

// import '../model_login/forgot_password.dart';
import '../screens/forgot_password_screen.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';
import '../constants/app_colors.dart';
import '../main.dart';
import '../services/auth_service.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.green),
              SizedBox(width: 10),
              Text('Login Failed'),
            ],
          ),
          content: Text('Vui lòng kiểm tra lại tên đăng nhập và mật khẩu'),
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

  Future<void> _login() async {
    try {
      final result = await _authService.login(
        _usernameController.text,
        _passwordController.text,
      );
      _showSnackBar(context, 'Login successful: ${result['accessToken']}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      _showErrorDialog(context, 'Vui lòng kiểm tra lại tên đăng nhập và mật khẩu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LoginConstants.loginTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 20),
        CustomTextField(
          controller: _usernameController,
          hintText: LoginConstants.emailHint,
          onTap: () => _showSnackBar(context, LoginConstants.emailTapMessage),
        ),
        SizedBox(height: 15),
        CustomTextField(
          controller: _passwordController,
          hintText: LoginConstants.passwordHint,
          obscureText: !_isPasswordVisible,
          onTap: () => _showSnackBar(context, LoginConstants.passwordTapMessage),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              size: 18,
            ),
            onPressed: _togglePasswordVisibility,
          ),
        ),
        SizedBox(height: 15),
        CustomButton(
          text: LoginConstants.loginButtonText,
          onPressed: _login,
          color: AppColors.accentGreen,
        ),
        SizedBox(height: 15),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
              );
            },
            child: Text(
              LoginConstants.forgotPasswordText,
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
            Expanded(child: Divider(color: Colors.white.withOpacity(0.8))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                LoginConstants.orText,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.8))),
          ],
        ),
        SizedBox(height: 20),
        CustomButton(
          icon: FontAwesomeIcons.facebookF,
          text: LoginConstants.facebookLoginText,
          onPressed: () => _showSnackBar(context, LoginConstants.facebookLoginMessage),
          color: Colors.white,
          textColor: Colors.blue,
        ),
        CustomButton(
          icon: FontAwesomeIcons.google,
          text: LoginConstants.googleLoginText,
          onPressed: () => _showSnackBar(context, LoginConstants.googleLoginMessage),
          color: Colors.white,
          textColor: Colors.red,
        ),
        CustomButton(
          icon: FontAwesomeIcons.apple,
          text: LoginConstants.appleLoginText,
          onPressed: () => _showSnackBar(context, LoginConstants.appleLoginMessage),
          color: Colors.white,
          textColor: Colors.black,
        ),
        SizedBox(height: 25),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
            child: Text.rich(
              TextSpan(
                text: LoginConstants.noAccountText,
                style: TextStyle(color: Colors.white, fontSize: 14),
                children: [
                  TextSpan(
                    text: LoginConstants.signUpText,
                    style: TextStyle(
                      color: AppColors.accentGreen,
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
    );
  }
}