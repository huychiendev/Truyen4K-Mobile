import 'package:flutter/material.dart';

class DailyMissionsScreen extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final int level;
  final double progressValue;
  final List<bool> dailyCheckins;

  const DailyMissionsScreen({
    Key? key,
    required this.username,
    required this.avatarUrl,
    required this.level,
    required this.progressValue,
    required this.dailyCheckins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Nhiệm vụ hàng ngày'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserHeader(),
            _buildDailyCheckin(),
            _buildMissionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Lv: $level',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progressValue,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          CircleAvatar(
            backgroundColor: Colors.white24,
            child: Text(
              'K',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCheckin() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đã điểm danh ... ngày',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              6,
                  (index) => _buildDayItem(index + 1, dailyCheckins[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(int day, bool isChecked) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isChecked ? Colors.amber : Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star,
            color: isChecked ? Colors.white : Colors.grey,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Day $day',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMissionsList() {
    final missions = [
      {'icon': Icons.thumb_up, 'title': 'Like truyện 1 lần', 'reward': 10},
      {'icon': Icons.monetization_on, 'title': 'Nạp tiền 1 lần', 'reward': 50},
      {'icon': Icons.check_circle, 'title': 'Điểm danh hàng ngày', 'reward': 20},
      {'icon': Icons.book, 'title': 'Đọc truyện 30p', 'reward': 30},
    ];

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhiệm vụ hàng ngày',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...missions.map((mission) => _buildMissionItem(
            mission['icon'] as IconData,
            mission['title'] as String,
            mission['reward'] as int,
          )),
        ],
      ),
    );
  }

  Widget _buildMissionItem(IconData icon, String title, int reward) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              'nhận',
              style: TextStyle(color: Colors.green),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}