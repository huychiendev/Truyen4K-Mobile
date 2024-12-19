import 'package:apptruyenonline/screens/self_screen/bag/avatarlevel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:apptruyenonline/models/ProfileModel.dart';
import 'package:apptruyenonline/models/User.dart';

class WalletScreen extends StatelessWidget {
  final String username;
  final String email;
  final int balance;
  final int diamondBalance;
  final UserProfile userProfile;
  final UserImage? userImage;

  const WalletScreen({
    Key? key,
    required this.username,
    required this.email,
    this.balance = 0,
    this.diamondBalance = 0,
    required this.userProfile,
    this.userImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Túi của tôi',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildUserCard(),
          _buildMenuList(context), // Pass context here
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade900, Colors.deepPurple.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: _getProfileImage(),
                backgroundColor: Colors.grey[300],
                onBackgroundImageError: (exception, stackTrace) {
                  print('Error loading avatar image: $exception');
                },
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userProfile.email,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Text(
                  userProfile.tierName,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBalanceItem(
                Icons.diamond_outlined,
                userProfile.diamondBalance.toString(),
                'Kim cương',
                Colors.blue,
              ),
              Container(height: 40, width: 1, color: Colors.white24),
              _buildBalanceItem(
                Icons.monetization_on_outlined,
                userProfile.coinBalance.toString(),
                'Xu',
                Colors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (userImage?.data != null) {
      try {
        return MemoryImage(base64Decode(userImage!.data));
      } catch (e) {
        print('Error decoding image data: $e');
        return AssetImage('assets/avt.png');
      }
    }
    return AssetImage('assets/avt.png');
  }

  Widget _buildBalanceItem(IconData icon, String amount, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildMenuList(BuildContext context) {  // Accept context here
    final menuItems = [
      {'icon': Icons.star, 'title': 'Huy hiệu', 'color': Colors.amber},
      {'icon': Icons.account_circle, 'title': 'Khung Avatar', 'color': Colors.blue},
      {'icon': Icons.chat_bubble, 'title': 'Khung Chat', 'color': Colors.green},
    ];

    return Column(
      children: menuItems
          .map((item) => _buildMenuItem(
        context,  // Pass context here
        item['icon'] as IconData,
        item['title'] as String,
        item['color'] as Color,
      ))
          .toList(),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.white54),
        onTap: () {
          if (title == 'Huy hiệu') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AvatarLevelsScreen()),
            );
          }
        },
      ),
    );
  }
}
