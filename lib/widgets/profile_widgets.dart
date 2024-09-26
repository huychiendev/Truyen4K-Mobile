import 'package:flutter/material.dart';
import 'dart:convert';

import '../screens/self_screen/profile_view_screen/personal_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  final String title;

  const ProfileHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String username;
  final String email;
  final String tierName;
  final String? imageUrl;
  final String? data;

  const ProfileInfo({
    Key? key,
    required this.username,
    required this.email,
    required this.tierName,
    this.imageUrl,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonalProfileScreen()),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: _getProfileImage(),
          radius: 25,
        ),
        title: Text(username, style: TextStyle(color: Colors.white)),
        subtitle: Text(email, style: TextStyle(color: Colors.grey)),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tierName,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (data != null && data!.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(data!));
      } catch (e) {
        print('Error decoding image: $e');
      }
    }
    return AssetImage('assets/avt.png');
  }
}

class MenuItem {
  final IconData icon;
  final String title;

  MenuItem(this.icon, this.title);
}

class ProfileMenuItems extends StatelessWidget {
  final List<MenuItem> items;
  final Function(String) onItemTap;

  const ProfileMenuItems({
    Key? key,
    required this.items,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((item) => ListTile(
        leading: Icon(item.icon, color: Colors.white),
        title: Text(item.title, style: TextStyle(color: Colors.white)),
        onTap: () => onItemTap(item.title),
      ))
          .toList(),
    );
  }
}

class HelpButton extends StatelessWidget {
  final VoidCallback onTap;

  const HelpButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: onTap,
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
    );
  }
}