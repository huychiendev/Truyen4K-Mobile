import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tôi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              SizedBox(height: 20),
              _buildMenuItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên người dùng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('example@email.com'),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      {'icon': Icons.notifications, 'title': 'Thông báo'},
      {'icon': Icons.payment, 'title': 'Thanh toán'},
      {'icon': Icons.settings, 'title': 'Cài đặt'},
      {'icon': Icons.help, 'title': 'Trợ giúp'},
      {'icon': Icons.info, 'title': 'Về chúng tôi'},
    ];

    return Column(
      children: menuItems.map((item) =>
          ListTile(
            leading: Icon(item['icon'] as IconData, color: Colors.green),
            title: Text(item['title'] as String),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Handle menu item tap
            },
          )
      ).toList(),
    );
  }
}