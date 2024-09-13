import 'package:apptruyenonline/screens/self_screen/payment_screen/account_payment_screen.dart';
import 'package:apptruyenonline/screens/self_screen/register_screen/prime2_screen.dart';
import 'package:apptruyenonline/screens/self_screen/register_screen/prime_screen.dart';
import 'package:flutter/material.dart';
import 'package:apptruyenonline/screens/self_screen/profile_view_screen/personal_profile_screen.dart';
import '../login/login_screen.dart';


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
              _buildMenuItem(Icons.person, 'Xem hồ sơ', context),
              _buildMenuItem(Icons.payment, 'Quản lý thanh toán', context),
              _buildMenuItem(Icons.star, 'Đăng ký', context), // Sửa lại chữ "Đăng ký"
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
        } else if (title == 'Quản lý thanh toán') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccountScreen()), // Đảm bảo màn hình PaymentScreen1 đã được định nghĩa
          );
        } else if (title == 'Đăng ký') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PremiumScreen1()), // Thay thế bằng màn hình đăng ký chính xác
          );
        } else if (title == 'Đăng xuất') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      },
    );
  }
}

// else if (title == 'Câu hỏi - hỏi đáp') {
  // Navigator.push(
  // context,
  // MaterialPageRoute(builder: (context) => FAQScreen()), // Thay thế FAQScreen bằng màn hình câu hỏi - hỏi đáp
  // );
  // }