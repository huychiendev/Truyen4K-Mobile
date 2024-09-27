import 'package:flutter/material.dart';
import '../../screens/authenticator/reset_password.dart';
import '../../services/auth_service.dart';
import 'custom_text_field_forgot_password.dart';
import '../../constants/forgot_password_constants.dart';
// import 'reset_password.dart'; // Import trang đặt lại mật khẩu

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtp(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await AuthService.sendOtp(_emailController.text.trim());
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ForgotPasswordConstants.otpSentMessage)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ForgotPasswordConstants.otpFailedMessage)),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $error')),
      );
    }
  }

  Future<void> _verifyOtp(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Gọi API xác minh OTP
      bool otpValid = await AuthService.verifyOtp(
        email: _emailController.text.trim(),
        otp: _otpController.text.trim(),
      );
      setState(() {
        _isLoading = false;
      });

      if (otpValid) {
        // Nếu OTP đúng, chuyển sang trang đặt lại mật khẩu
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPassword(email: _emailController.text),
          ),
        );
      } else {
        // Nếu OTP sai, hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP không hợp lệ. Vui lòng thử lại.')),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _emailController,
            labelText: ForgotPasswordConstants.emailHint,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _otpController,
                  labelText: ForgotPasswordConstants.otpHint,
                ),
              ),
              SizedBox(width: 10),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () => _sendOtp(context),
                child: Text(ForgotPasswordConstants.sendOtpButton),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _verifyOtp(context),
            child: Text(ForgotPasswordConstants.confirmButton),
          ),
        ],
      ),
    );
  }
}
