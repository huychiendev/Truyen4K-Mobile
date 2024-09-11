import 'package:flutter/material.dart';
import 'package:apptruyenonline/screens/profile_screen/personal_profile_screen.dart';

import '../login/login_screen.dart'; // Import the personal profile screen

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Tài khoản',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/avt.png'),
                  radius: 25,
                ),
                title: Text('LVuxyz', style: TextStyle(color: Colors.white)),
                subtitle: Text('lvu.byte@gmail.com',
                    style: TextStyle(color: Colors.grey)),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('VIP',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
              Divider(color: Colors.grey.shade800),
              _buildMenuItem(Icons.person, 'Xem hồ sơ', context), // Pass context here
              _buildMenuItem(Icons.payment, 'Quản lý thanh toán', context),
              _buildMenuItem(Icons.star, 'Đăng ký', context),
              _buildMenuItem(Icons.help, 'Câu hỏi - hỏi đáp', context),
              _buildMenuItem(Icons.exit_to_app, 'Đăng xuất', context),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.headset_mic, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Hãy hỏi, chúng tôi sẵn sàng trợ giúp',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildMenuItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: () {
        if (title == 'Xem hồ sơ') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonalProfileScreen()),
          );
        }else if (title == 'Đăng xuất') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }


        // Add other navigation if needed for other menu items
      },
    );
  }
}
