import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/login_constants.dart';
import '../model_login/forgot_password.dart';
import '../model_login/sign_up_screen.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';
import '../constants/app_colors.dart';
import '../main.dart';


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
          hintText: LoginConstants.emailHint,
          onTap: () => _showSnackBar(context, LoginConstants.emailTapMessage),
        ),
        SizedBox(height: 15),
        CustomTextField(
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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
          color: AppColors.accentGreen,
        ),
        SizedBox(height: 15),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPassword()),
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