import 'package:flutter/material.dart';
import '../../../models/ProfileModel.dart';
import '../../../services/profile_service.dart';

class AchievementScreen extends StatefulWidget {
  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final userData = await ProfileService.getUserData();
      setState(() {
        _userProfile = userData['profile'] as UserProfile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildCultivationLevel() {
    if (_userProfile == null) return SizedBox.shrink();

    return Container(
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
          Row(
            children: [
              Image.asset(
                'assets/level/${_userProfile!.tierName}.webp',
                width: 60,
                height: 60,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cấp độ tu luyện',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _userProfile!.tierName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.menu_book, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${_userProfile!.chapterReadCount} chương',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Điểm tích lũy', '${_userProfile!.point}'),
              _buildStatItem('Xu đã tiêu', '${_userProfile!.coinSpent}'),
              _buildStatItem('Người theo dõi', '${_userProfile!.followerCount}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

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
      body: RefreshIndicator(
        onRefresh: _fetchUserData,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _fetchUserData,
                child: Text('Thử lại'),
              ),
            ],
          ),
        )
            : SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCultivationLevel(),
                SizedBox(height: 24),
                _buildOverallProgress(),
                SizedBox(height: 24),
                _buildAchievementCategories(),
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

  Widget _buildOverallProgress() {
    if (_userProfile == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
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
                    'Tổng thành tựu',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${_userProfile!.point}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' điểm',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
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
                  'TOP ${_calculateRank()}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateRank() {
    // This is a placeholder. You would typically calculate this based on the user's
    // points relative to other users, perhaps from an API endpoint
    if (_userProfile!.point > 1000) return '100';
    if (_userProfile!.point > 500) return '500';
    return '1000+';
  }

  Widget _buildAchievementCategories() {
    if (_userProfile == null) return SizedBox.shrink();

    final readingAchievements = [
      {
        'icon': Icons.menu_book,
        'title': 'Đọc truyện',
        'progress': _userProfile!.chapterReadCount,
        'required': 100,
        'unit': 'chương',
        'reward': '500 xu',
        'color': Colors.blue,
      },
      {
        'icon': Icons.access_time,
        'title': 'Thời gian đọc',
        'progress': _userProfile!.point,
        'required': 1000,
        'unit': 'phút',
        'reward': '200 xu',
        'color': Colors.green,
      },
    ];

    final interactionAchievements = [
      {
        'icon': Icons.thumb_up,
        'title': 'Tương tác',
        'progress': _userProfile!.followerCount,
        'required': 50,
        'unit': 'lượt',
        'reward': '300 xu',
        'color': Colors.orange,
      },
      {
        'icon': Icons.monetization_on,
        'title': 'Chi tiêu',
        'progress': _userProfile!.coinSpent,
        'required': 1000,
        'unit': 'xu',
        'reward': '400 xu',
        'color': Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thành tựu đọc truyện',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...readingAchievements.map((achievement) =>
            _buildAchievementItem(achievement)).toList(),
        SizedBox(height: 24),
        Text(
          'Thành tựu tương tác',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...interactionAchievements.map((achievement) =>
            _buildAchievementItem(achievement)).toList(),
      ],
    );
  }

  Widget _buildAchievementItem(Map<String, dynamic> achievement) {
    final progress = achievement['progress'] as int;
    final required = achievement['required'] as int;
    final progressPercent = (progress / required).clamp(0.0, 1.0);
    final color = achievement['color'] as Color;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  achievement['icon'] as IconData,
                  color: color,
                  size: 24,
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Phần thưởng: ${achievement['reward']}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$progress/${achievement['required']} ${achievement['unit']}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressPercent,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}