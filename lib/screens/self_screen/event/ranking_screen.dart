import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Bảng Xếp Hạng', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          tabs: [
            Tab(text: 'Tuần'),
            Tab(text: 'Tháng'),
            Tab(text: 'Tổng'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRankingList('weekly'),
          _buildRankingList('monthly'),
          _buildRankingList('all-time'),
        ],
      ),
    );
  }

  Widget _buildRankingList(String type) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 20,
      itemBuilder: (context, index) {
        return _buildRankingItem(index + 1);
      },
    );
  }

  Widget _buildRankingItem(int rank) {
    Color rankColor;
    Widget rankWidget;

    if (rank == 1) {
      rankColor = Colors.amber;
      rankWidget = Icon(Icons.emoji_events, color: rankColor, size: 32);
    } else if (rank == 2) {
      rankColor = Colors.grey[300]!;
      rankWidget = Icon(Icons.emoji_events, color: rankColor, size: 32);
    } else if (rank == 3) {
      rankColor = Colors.brown;
      rankWidget = Icon(Icons.emoji_events, color: rankColor, size: 32);
    } else {
      rankColor = Colors.white;
      rankWidget = Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Text(
          rank.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rank <= 3 ? rankColor.withOpacity(0.5) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          rankWidget,
          SizedBox(width: 16),
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/avt.png'),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Level: Đấu Giả',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '1000',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'điểm',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}