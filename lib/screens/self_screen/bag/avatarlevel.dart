import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apptruyenonline/models/ProfileModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarLevelsScreen extends StatefulWidget {
  @override
  _AvatarLevelsScreenState createState() => _AvatarLevelsScreenState();
}

class _AvatarLevelsScreenState extends State<AvatarLevelsScreen> {
  final Map<String, int> cultivationLevels = {
    'Đấu Khí': 0,
    'Đấu Giả': 51,
    'Đấu Sư': 151,
    'Đại Đấu Sư': 301,
    'Đấu Linh': 501,
    'Đấu Vương': 801,
    'Đấu Hoàng': 1201,
    'Đấu Tông': 1801,
    'Đấu Tôn': 2501,
    'Đấu Thánh': 3501,
    'Đấu Đế': 5001,
  };

  String _currentLevel = 'Đấu Khí';
  int _userChapterCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    // Get the actual chapter count from user profile instead of SharedPreferences
    final String? username = prefs.getString('username');
    final String? token = prefs.getString('auth_token');

    if (username != null && token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/v1/profile/$username'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final profileData = json.decode(utf8.decode(response.bodyBytes));
          final userProfile = UserProfile.fromJson(profileData);
          final chapterCount = userProfile.chapterReadCount;
          final level = _calculateUserLevel(chapterCount);

          if (mounted) {
            setState(() {
              _userChapterCount = chapterCount;
              _currentLevel = level;
            });
          }
        }
      } catch (e) {
        print('Error loading user progress: $e');
      }
    }
  }

  String _calculateUserLevel(int chapterCount) {
    String level = 'Đấu Khí';
    for (var entry in cultivationLevels.entries) {
      if (chapterCount >= entry.value) {
        level = entry.key;
      } else {
        break;
      }
    }
    return level;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Cấp độ tu luyện', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildCurrentLevelCard(),
          Expanded(
            child: _buildLevelsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLevelCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade900, Colors.purple.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Cấp độ hiện tại',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          // Use the same asset path structure as in _buildCultivationIcon
          Image.asset(
            'assets/level/$_currentLevel.webp',
            width: 100,
            height: 100,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading level image: $error');
              return Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.white70,
              );
            },
          ),
          SizedBox(height: 16),
          Text(
            _currentLevel,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$_userChapterCount chương đã đọc',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: cultivationLevels.length,
      itemBuilder: (context, index) {
        final level = cultivationLevels.keys.elementAt(index);
        final requiredChapters = cultivationLevels[level]!;
        final isUnlocked = _userChapterCount >= requiredChapters;
        final isCurrentLevel = level == _currentLevel;

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isCurrentLevel ? Colors.purple.withOpacity(0.2) : Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: isCurrentLevel
                ? Border.all(color: Colors.purple, width: 2)
                : null,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 60,
              height: 60,
              child: isUnlocked
                  ? Image.asset(
                'assets/level/$level.webp',
                width: 60,
                height: 60,
              )
                  : ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.saturation,
                ),
                child: Image.asset(
                  'assets/level/$level.webp',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            title: Text(
              level,
              style: TextStyle(
                color: isUnlocked ? Colors.white : Colors.grey,
                fontWeight: isCurrentLevel ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              'Yêu cầu: $requiredChapters chương',
              style: TextStyle(
                color: isUnlocked ? Colors.white70 : Colors.grey,
              ),
            ),
            trailing: isUnlocked
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.lock, color: Colors.grey),
          ),
        );
      },
    );
  }
}