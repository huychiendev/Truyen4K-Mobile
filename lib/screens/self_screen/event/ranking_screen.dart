import 'package:apptruyenonline/screens/self_screen/event/ranking_service.dart';
import 'package:apptruyenonline/screens/self_screen/event/ranking_user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<RankingUser> _readingRankings = [];
  List<RankingUser> _topNovelRankings = [];
  List<RankingUser> _topUserRankings = [];
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

      print('Starting to fetch rankings...');

      final results = await Future.wait([
        RankingService.fetchTopReaders(),
        RankingService.fetchTopNovels(),
        RankingService.fetchTopUsers(),
      ]);

      print('Weekly Rankings: ${results[0].length} items');
      print('Novel Rankings: ${results[1].length} items');
      print('User Rankings: ${results[2].length} items');

      if (mounted) {
        setState(() {
          _readingRankings = results[0];
          _topNovelRankings = results[1];
          _topUserRankings = results[2];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Fetching error: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
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
            Tab(text: 'Đọc Tuần'),
            Tab(text: 'Truyện Được Đọc Nhiều'),
            Tab(text: 'Cao Thủ Tuần'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRankings,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _error != null
            ? _buildErrorWidget()
            : TabBarView(
          controller: _tabController,
          children: [
            _buildWeeklyList(_readingRankings),
            _buildNovelList(_topNovelRankings),
            _buildUserList(_topUserRankings),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyList(List<RankingUser> rankings) {
    if (rankings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        return _buildWeeklyRankingItem(index + 1, rankings[index]);
      },
    );
  }

  Widget _buildNovelList(List<RankingUser> rankings) {
    if (rankings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        return _buildWeeklyRankingItem(index + 1, rankings[index]);
      },
    );
  }

  Widget _buildUserList(List<RankingUser> rankings) {
    if (rankings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        return _buildWeeklyRankingItem(index + 1, rankings[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Không có dữ liệu xếp hạng',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchRankings,
            child: Text('Tải lại'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
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
    );
  }

  Widget _buildRankingList(List<RankingUser> rankings, {bool showPoints = true}) {
    if (rankings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Không có dữ liệu xếp hạng',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchRankings,
              child: Text('Tải lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _tabController.animation!,
          builder: (context, child) {
            return FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _tabController.animation!,
                  curve: Interval(
                    0.5 * index / rankings.length,
                    0.5 + 0.5 * index / rankings.length,
                    curve: Curves.easeOut,
                  ),
                ),
              ),
              child: child,
            );
          },
          child: _buildWeeklyRankingItem(index + 1, rankings[index]),
        );
      },
    );
  }

  Widget _buildWeeklyRankingItem(int rank, RankingUser user) {
    Color rankColor = _getRankColor(rank);
    Widget rankWidget = _buildRankWidget(rank, rankColor);

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
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/avt.png',
                image: user.imagePath,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  user.tierName,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
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


  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold for first place
      case 2:
        return Colors.grey[300]!; // Silver for second place
      case 3:
        return Colors.brown; // Bronze for third place
      default:
        return Colors.white; // Default color for other rankings
    }
  }

  Widget _buildRankWidget(int rank, Color color) {
    if (rank <= 3) {
      return Icon(
        Icons.emoji_events,
        color: color,
        size: 32,
      );
    } else {
      return Container(
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
  }
}
