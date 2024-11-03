import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptruyenonline/services/profile_service.dart';
import 'package:apptruyenonline/widgets/profile_widgets.dart';
import 'package:apptruyenonline/models/ProfileModel.dart';
import 'package:apptruyenonline/screens/authenticator/login_screen.dart';
import 'package:apptruyenonline/screens/self_screen/profile_view_screen/personal_profile_screen.dart';
import 'package:apptruyenonline/screens/self_screen/payment_screen/account_payment_screen.dart';
import 'package:apptruyenonline/screens/self_screen/register_screen/prime_screen.dart';
import 'dart:convert';


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

  @override
  Widget build(BuildContext context) {
    if (_userProfile == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Tài Khoản'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(),
            _buildAccountFeatures(),
            _buildDailyActivities(),
            _buildMyPrivileges(),
            _buildFeedbackSection(),
            Divider(color: Colors.grey.shade800),
            _buildMenuItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: _userProfile?.data != null
                ? MemoryImage(base64Decode(_userProfile!.data!))
                : AssetImage('assets/avt.png') as ImageProvider,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userProfile!.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _userProfile!.email,
                  style: TextStyle(color: Colors.grey),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _userProfile!.tierName,
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountFeatures() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PremiumScreen1()),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Truyện 247 vip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Xem chi tiết',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFeatureButton(
                  icon: Icons.account_balance_wallet,
                  label: 'Ví',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountScreen()),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildFeatureButton(
                  icon: Icons.shopping_bag,
                  label: 'Túi',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyActivities() {
    return InkWell(
      onTap: () {
        // Add daily tasks functionality
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Điểm danh hàng ngày',
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMyPrivileges() {
    final privileges = [
      {'icon': Icons.person, 'title': 'Level ${_userProfile!.tierName}'},
      {'icon': Icons.event, 'title': 'Sự kiện'},
      {'icon': Icons.app_registration, 'title': 'Đăng ký'},
      {'icon': Icons.star, 'title': 'Thành tựu'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Đặc quyền của tôi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: privileges.map((item) => _buildPrivilegeItem(
              item['icon'] as IconData,
              item['title'] as String,
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivilegeItem(IconData icon, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Phản hồi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.help_outline, color: Colors.white),
          title: Text(
            'Trợ giúp và phản hồi',
            style: TextStyle(color: Colors.white),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => _showHelpDialog(context),
        ),
        ListTile(
          leading: Icon(Icons.star_border, color: Colors.white),
          title: Text(
            'Đánh giá',
            style: TextStyle(color: Colors.white),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () => _showHelpDialog(context),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.payment, color: Colors.white),
          title: Text('Quản lý thanh toán', style: TextStyle(color: Colors.white)),
          onTap: () => _handleMenuItemTap('Quản lý thanh toán'),
        ),
        ListTile(
          leading: Icon(Icons.star, color: Colors.white),
          title: Text('Đăng ký', style: TextStyle(color: Colors.white)),
          onTap: () => _handleMenuItemTap('Đăng ký'),
        ),
        ListTile(
          leading: Icon(Icons.help, color: Colors.white),
          title: Text('Câu hỏi - hỏi đáp', style: TextStyle(color: Colors.white)),
          onTap: () => _handleMenuItemTap('Câu hỏi - hỏi đáp'),
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app, color: Colors.white),
          title: Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          onTap: () => _handleMenuItemTap('Đăng xuất'),
        ),
      ],
    );
  }
}