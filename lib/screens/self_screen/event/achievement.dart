// lib/screens/achievement/achievement_screen.dart

import 'package:flutter/material.dart';

class AchievementScreen extends StatelessWidget {
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
        title: Text('Thành Tựu', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => _showHelp(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverallProgress(),
              SizedBox(height: 24),
              _buildAchievementCategories(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallProgress() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade900, Colors.green.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cấp độ đọc truyện',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Đấu Giả',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '12/50 thành tựu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.45,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Cần thêm 500 điểm để lên cấp',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCategories() {
    final categories = [
      {
        'title': 'Thành tựu đọc truyện',
        'icon': Icons.book,
        'achievements': _readingAchievements,
      },
      {
        'title': 'Thành tựu tương tác',
        'icon': Icons.chat_bubble,
        'achievements': _interactionAchievements,
      },
      {
        'title': 'Thành tựu đặc biệt',
        'icon': Icons.star,
        'achievements': _specialAchievements,
      },
    ];

    return Column(
      children: categories.map((category) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Icon(category['icon'] as IconData, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    category['title'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...(category['achievements'] as List<Map<String, dynamic>>).map(
                  (achievement) => _buildAchievementCard(achievement),
            ),
            SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final bool isLocked = achievement['progress'] < achievement['required'];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLocked ? Colors.grey[800]! : Colors.green,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showAchievementDetails(achievement),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isLocked ? Colors.grey : Colors.green).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    achievement['icon'] as IconData,
                    color: isLocked ? Colors.grey : Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement['title'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${achievement['progress']}/${achievement['required']} ${achievement['unit']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: achievement['progress'] / achievement['required'],
                          backgroundColor: Colors.grey[800],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isLocked ? Colors.grey : Colors.green,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                if (!isLocked)
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.green, size: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Hệ thống thành tựu',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Hoàn thành các thành tựu để nhận thưởng và nâng cấp độ đọc truyện. '
              'Mỗi thành tựu sẽ có phần thưởng khác nhau như xu, kim cương hoặc điểm kinh nghiệm.',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đã hiểu', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    // Show achievement details dialog
  }

  final List<Map<String, dynamic>> _readingAchievements = [
    {
      'icon': Icons.menu_book,
      'title': 'Đọc 100 chương truyện',
      'progress': 45,
      'required': 100,
      'unit': 'chương',
      'reward': '500 xu',
    },
    {
      'icon': Icons.access_time,
      'title': 'Đọc truyện 7 ngày liên tiếp',
      'progress': 5,
      'required': 7,
      'unit': 'ngày',
      'reward': '200 xu',
    },
  ];

  final List<Map<String, dynamic>> _interactionAchievements = [
    {
      'icon': Icons.comment,
      'title': 'Viết 50 bình luận',
      'progress': 23,
      'required': 50,
      'unit': 'bình luận',
      'reward': '300 xu',
    },
    {
      'icon': Icons.thumb_up,
      'title': 'Thích 100 truyện',
      'progress': 100,
      'required': 100,
      'unit': 'truyện',
      'reward': '400 xu',
    },
  ];

  final List<Map<String, dynamic>> _specialAchievements = [
    {
      'icon': Icons.military_tech,
      'title': 'Top 100 người đọc',
      'progress': 1,
      'required': 1,
      'unit': 'lần',
      'reward': '1000 xu',
    },
    {
      'icon': Icons.diamond,
      'title': 'Nâng cấp VIP',
      'progress': 0,
      'required': 1,
      'unit': 'lần',
      'reward': '2000 xu',
    },
  ];
}