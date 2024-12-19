import 'package:apptruyenonline/screens/self_screen/event/ranking_user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptruyenonline/screens/self_screen/event/ranking_user.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<RankingUser> _rankings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchRankings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchRankings() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Vui lòng đăng nhập để xem bảng xếp hạng');
      }

      final response = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/bxh/top-read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _rankings = data.map((json) => RankingUser.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Không thể tải bảng xếp hạng');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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
      body: RefreshIndicator(
        onRefresh: _fetchRankings,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchRankings,
                child: Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        )
            : TabBarView(
          controller: _tabController,
          children: [
            _buildRankingList(_rankings),
            _buildRankingList(_rankings),
            _buildRankingList(_rankings),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingList(List<RankingUser> rankings) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        return _buildRankingItem(index + 1, rankings[index]);
      },
    );
  }

  Widget _buildRankingItem(int rank, RankingUser user) {
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
            backgroundColor: Colors.grey[800],
            child: ClipOval(
              child: Image.network(
                user.imagePath,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/avt.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Level: ${user.tierName}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.chapterReadCount}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'chương',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}