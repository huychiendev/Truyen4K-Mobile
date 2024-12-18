import 'package:apptruyenonline/screens/menu/coin_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptruyenonline/services/profile_service.dart';
import 'package:apptruyenonline/models/ProfileModel.dart';
import 'package:apptruyenonline/screens/authenticator/login_screen.dart';
import 'package:apptruyenonline/screens/self_screen/profile_view_screen/personal_profile_screen.dart';
import 'package:apptruyenonline/screens/self_screen/payment_screen/account_payment_screen.dart';
import 'package:apptruyenonline/screens/self_screen/register_screen/prime_screen.dart';
import 'package:apptruyenonline/screens/menu/daily_missions_screen.dart';
import 'package:apptruyenonline/screens/self_screen/wallet_screen.dart';
import 'dart:convert';
import '../../../models/User.dart';
import 'package:apptruyenonline/screens/self_screen/event/BXH.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;
  UserImage? _userImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await ProfileService.getUserData();
      if (mounted) {  // Check if widget is still mounted before setting state
        setState(() {
          _userProfile = userData['profile'] as UserProfile;
          _userImage = userData['image'] as UserImage?;
        });
      }
    } catch (e) {
      print('Failed to load user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data')),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('username');
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      print('Logout error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to logout')),
        );
      }
    }
  }

  int _getUserLevel() {
    // Implement logic to calculate user level based on _userProfile
    return 1;
  }

  double _getProgressValue() {
    // Implement logic to calculate progress value based on _userProfile
    return 0.5;
  }

  List<bool> _getDailyCheckins() {
    // Implement logic to get daily checkins data based on _userProfile
    return [true, true, false, false, false, false];
  }

  void _navigateToDailyMissions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyMissionsScreen(
          username: _userProfile!.username,
          level: _getUserLevel(),
          progressValue: _getProgressValue(),
          dailyCheckins: _getDailyCheckins(),
          userProfile: _userProfile!,
          userImage: _userImage,
        ),
      ),
    );
  }

  void _handleMenuItemTap(String title) async {
    if (!mounted) return;

    switch (title) {
      case 'Quản lý thanh toán':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountScreen()),
        );
        break;
      case 'Đăng ký':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PremiumScreen1()),
        );
        break;
      case 'Câu hỏi - hỏi đáp':
          context;
        break;
      case 'Đăng xuất':
        await _handleLogout();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Tài Khoản'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Implement settings functionality
              (context);
            },
          ),
        ],
      ),
      body: _userProfile == null
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchUserData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }
  Widget _buildUserHeader() {
    return InkWell(
      onTap: () {
        if (_userProfile != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonalProfileScreen()),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Hero(
              tag: 'profile_image',
              child: CircleAvatar(
                radius: 30,
                backgroundImage: _userImage?.data != null
                    ? MemoryImage(base64Decode(_userImage!.data))
                    : AssetImage('assets/avt.png') as ImageProvider,
                onBackgroundImageError: (exception, stackTrace) {
                  print('Error loading profile image: $exception');
                },
                backgroundColor: Colors.grey[300],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userProfile?.username ?? 'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_userProfile?.email != null)
                    Text(
                      _userProfile!.email,
                      style: TextStyle(color: Colors.grey),
                    ),
                  if (_userProfile?.tierName != null)
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Truyện 247 vip',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Xem chi tiết',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
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
                  onTap: () {
                    if (_userProfile != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoinWalletScreen(
                            username: _userProfile!.username,
                            email: _userProfile!.email,
                            coinBalance: _userProfile!.coinBalance,
                            userProfile: _userProfile!,
                            userImage: _userImage,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildFeatureButton(
                  icon: Icons.shopping_bag,
                  label: 'Túi',
                  onTap: () {
                    // Example navigation code
                    if (_userProfile != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WalletScreen(
                            username: _userProfile!.username,
                            email: _userProfile!.email,
                            balance: _userProfile!.coinBalance,
                            diamondBalance: _userProfile!.diamondBalance,
                            userProfile: _userProfile!,
                            userImage: _userImage,
                          ),
                        ),
                      );
                    }
                  },
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
      onTap: _navigateToDailyMissions,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.white),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Điểm danh hàng ngày',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Nhận quà mỗi ngày',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMyPrivileges() {
    final privileges = [
      {
        'icon': Icons.person,
        'title': 'Level ${_userProfile?.tierName ?? ""}',
        'color': Colors.blue
      },
      {
        'icon': Icons.event,
        'title': 'Sự kiện',
        'color': Colors.purple
      },
      {
        'icon': Icons.app_registration,
        'title': 'Đăng ký',
        'color': Colors.orange
      },
      {
        'icon': Icons.star,
        'title': 'Thành tựu',
        'color': Colors.green
      },
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
              item['color'] as Color,
            )).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildPrivilegeItem(IconData icon, String title, Color color) {
    return GestureDetector(
      onTap: () {
        if (title == 'Sự kiện') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventScreen()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
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
        _buildFeedbackItem(
          icon: Icons.help_outline,
          title: 'Trợ giúp và phản hồi',
          onTap: () => (context),
        ),
        _buildFeedbackItem(
          icon: Icons.star_border,
          title: 'Đánh giá',
          onTap: () => (context),
        ),
      ],
    );
  }

  Widget _buildFeedbackItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      {
        'icon': Icons.payment,
        'title': 'Quản lý thanh toán',
      },
      {
        'icon': Icons.star,
        'title': 'Đăng ký',
      },
      {
        'icon': Icons.help,
        'title': 'Câu hỏi - hỏi đáp',
      },
      {
        'icon': Icons.exit_to_app,
        'title': 'Đăng xuất',
      },
    ];

    return Column(
      children: menuItems
          .map((item) => ListTile(
        leading: Icon(item['icon'] as IconData, color: Colors.white),
        title: Text(
          item['title'] as String,
          style: TextStyle(color: Colors.white),
        ),
        onTap: () => _handleMenuItemTap(item['title'] as String),
      ))
          .toList(),
    );
  }
}