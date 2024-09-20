import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:apptruyenonline/screens/self_screen/profile_view_screen/personal_profile_screen.dart';
import '../../models/ProfileModel.dart';
import '../login/login_screen.dart';
import '../self_screen/payment_screen/account_payment_screen.dart';
import '../self_screen/register_screen/prime_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _email;

  @override
  void initState() {
    super.initState();
    _fetchAndSaveProfileData();
  }

  Future<void> _fetchAndSaveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/profile/huychien'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final profileData = json.decode(response.body);
        UserProfile userProfile = UserProfile.fromJson(profileData);

        // Save profile data and id to SharedPreferences
        await prefs.setString('user_profile', json.encode(userProfile.toJson()));
        await prefs.setInt('user_id', userProfile.id);

        // Load email from SharedPreferences
        setState(() {
          _email = userProfile.email;
        });

        // Print the user ID to verify
        print('User ID: ${userProfile.id}');
      } else {
        // Handle error
        print('Failed to load profile data');
      }
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
                subtitle: Text(_email ?? 'Loading...',
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
              _buildMenuItem(Icons.star, 'Đăng ký', context),
              _buildMenuItem(Icons.help, 'Câu hỏi - hỏi đáp', context),
              _buildMenuItem(Icons.exit_to_app, 'Đăng xuất', context),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thông báo'),
                          content: Text(
                              'Tính năng đang phát triển \n Thông cảm heng :)'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
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
              )
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
      onTap: () async {
        if (title == 'Xem hồ sơ') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonalProfileScreen()),
          );
        } else if (title == 'Quản lý thanh toán') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccountScreen()),
          );
        } else if (title == 'Đăng ký') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PremiumScreen1()),
          );
        } else if (title == 'Câu hỏi - hỏi đáp') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Thông báo'),
                content: Text('Tính năng đang phát triển \n Thông cảm heng :)'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (title == 'Đăng xuất') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('auth_token');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      },
    );
  }
}
