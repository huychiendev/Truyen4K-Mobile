import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptruyenonline/services/profile_service.dart';
import 'package:apptruyenonline/widgets/profile_widgets.dart';
import 'package:apptruyenonline/models/ProfileModel.dart';
import 'package:apptruyenonline/screens/authenticator/login_screen.dart';
import 'package:apptruyenonline/screens/self_screen/profile_view_screen/personal_profile_screen.dart';
import 'package:apptruyenonline/screens/self_screen/payment_screen/account_payment_screen.dart';
import 'package:apptruyenonline/screens/self_screen/register_screen/prime_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _fetchAndSaveProfileData();
  }

  Future<void> _fetchAndSaveProfileData() async {
    try {
      final profile = await ProfileService.fetchProfileData();
      setState(() {
        _userProfile = profile;
      });
    } catch (e) {
      print('Failed to load profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(title: 'Tài khoản'),
              if (_userProfile != null)
                ProfileInfo(
                  username: _userProfile!.username,
                  email: _userProfile!.email,
                  tierName: _userProfile!.tierName,
                  imageUrl: _userProfile!.imagePath,
                  data: _userProfile!.data, // Add this line
                )
              else
                Center(child: CircularProgressIndicator()),
              Divider(color: Colors.grey.shade800),
              ProfileMenuItems(
                onItemTap: _handleMenuItemTap,
                items: [
                  MenuItem(Icons.payment, 'Quản lý thanh toán'),
                  MenuItem(Icons.star, 'Đăng ký'),
                  MenuItem(Icons.help, 'Câu hỏi - hỏi đáp'),
                  MenuItem(Icons.exit_to_app, 'Đăng xuất'),
                ],
              ),
              Spacer(),
              HelpButton(
                onTap: () => _showHelpDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuItemTap(String title) async {
    switch (title) {
      case 'Quản lý thanh toán':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountScreen()),
        );
        break;
      case 'Đăng ký':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PremiumScreen1()),
        );
        break;
      case 'Câu hỏi - hỏi đáp':
        _showHelpDialog(context);
        break;
      case 'Đăng xuất':
        await _handleLogout();
        break;
    }
  }

  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('username');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Tính năng đang phát triển \n Thông cảm heng :)'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


