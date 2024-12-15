import 'package:apptruyenonline/screens/item_truyen/view_screen/novel_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/novel_model.dart';
import '../../services/explore_service.dart';

class AuthorDetailScreen extends StatefulWidget {
  final String authorName;
  final int authorId;

  const AuthorDetailScreen({
    Key? key,
    required this.authorName,
    required this.authorId,
  }) : super(key: key);

  @override
  _AuthorDetailScreenState createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> with SingleTickerProviderStateMixin {
  final ExploreService _exploreService = ExploreService();
  Map<String, dynamic>? authorData;
  List<Novel> authorNovels = [];
  bool isLoading = true;
  String? error;
  bool isFollowing = false;
  int followerCount = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAuthorData();
    _checkFollowStatus();
    _getFollowerCount();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<String?> _getCurrentUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> _checkFollowStatus() async {
    try {
      String? username = await _getCurrentUsername();
      if (username == null) return;

      final response = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/following/$username'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> following = json.decode(response.body);
        setState(() {
          isFollowing = following.any((author) => author['id'] == widget.authorId);
        });
      }
    } catch (e) {
      print('Error checking follow status: $e');
    }
  }

  Future<void> _getFollowerCount() async {
    try {
      final response = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/followers/${widget.authorId}'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> followers = json.decode(response.body);
        setState(() {
          followerCount = followers.length;
        });
      }
    } catch (e) {
      print('Error getting follower count: $e');
    }
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<void> _toggleFollow() async {
    try {
      String? username = await _getCurrentUsername();
      if (username == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng đăng nhập để theo dõi tác giả')),
        );
        return;
      }

      final String endpoint = isFollowing ? 'unfollow' : 'follow';
      final response = await http.post(
        Uri.parse('http://14.225.207.58:9898/api/v1/$endpoint/author')
            .replace(queryParameters: {
          'currentUsername': username,
          'authorId': widget.authorId.toString(),
        }),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFollowing = !isFollowing;
          followerCount += isFollowing ? 1 : -1;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isFollowing ? 'Đã theo dõi tác giả' : 'Đã hủy theo dõi')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại sau.')),
      );
    }
  }

  Future<void> _loadAuthorData() async {
    try {
      setState(() => isLoading = true);

      // Fetch author details
      final authorResponse = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/authors/${widget.authorId}'),
        headers: await _getAuthHeaders(),
      );

      // Use ExploreService to fetch author's novels
      final novels = await _exploreService.searchNovelsByAuthor(widget.authorName);

      final authorInfo = authorResponse.statusCode == 200
          ? json.decode(utf8.decode(authorResponse.bodyBytes))
          : {
        'name': widget.authorName,
        'id': widget.authorId,
        'dob': null,
        'bio': 'Chưa có thông tin',
      };

      setState(() {
        authorData = authorInfo;
        authorNovels = novels;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
        authorData = {
          'name': widget.authorName,
          'id': widget.authorId,
          'dob': null,
          'bio': 'Chưa có thông tin',
        };
        authorNovels = [];
      });
    }
  }

  Widget _buildAuthorInfo() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[900]!, Colors.grey[850]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[800],
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorData?['name'] ?? widget.authorName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.grey[400]),
                        SizedBox(width: 4),
                        Text(
                          '$followerCount người theo dõi',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Tham gia: ${_formatDate(authorData?['dob'])}',
            style: TextStyle(color: Colors.grey[400]),
          ),
          SizedBox(height: 16),
          Text(
            authorData?['bio'] ?? 'Chưa có thông tin',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _toggleFollow,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing ? Colors.grey[800] : Colors.green,
              minimumSize: Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isFollowing ? 'Đang theo dõi' : 'Theo dõi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 45, // Chiều cao cố định
      decoration: BoxDecoration(
        color: Colors.grey[900], // Màu nền tối
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: ClipRRect( // Để tránh indicator vượt ra ngoài border radius
        borderRadius: BorderRadius.circular(25),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            // Gradient cho tab được chọn
            gradient: LinearGradient(
              colors: [
                Colors.purple[700]!,
                Colors.deepPurple[800]!,
              ],
            ),
          ),
          // Loại bỏ divider mặc định
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          // Padding cho text
          labelPadding: EdgeInsets.zero,
          // Style cho text được chọn
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          // Style cho text không được chọn
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          // Thêm overlay color khi tap
          overlayColor: MaterialStateProperty.all(Colors.transparent),

          tabs: [
            Tab(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text('Tác phẩm'),
              ),
            ),
            Tab(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text('Thông tin'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNovelsList() {
    if (authorNovels.isEmpty) {
      return Center(
        child: Text(
          'Chưa có tác phẩm nào',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: authorNovels.length,
      itemBuilder: (context, index) {
        final novel = authorNovels[index];
        return Card(
          color: Colors.grey[900],
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(novel.thumbnailImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              novel.title,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${novel.averageRatings}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.book, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${novel.totalChapters} chương',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovelDetailScreen(slug: novel.slug),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAuthorDetails() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildInfoItem('Tên tác giả', authorData?['name'] ?? widget.authorName),
        _buildInfoItem('ID', widget.authorId.toString()),
        _buildInfoItem('Ngày tham gia', _formatDate(authorData?['dob'])),
        _buildInfoItem('Số tác phẩm', authorNovels.length.toString()),
        _buildInfoItem('Người theo dõi', followerCount.toString()),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Chưa có thông tin';
    }
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Ngày không hợp lệ';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black87,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Thông tin tác giả', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadAuthorData();
          await _checkFollowStatus();
          await _getFollowerCount();
        },
        child: Column(
          children: [
            _buildAuthorInfo(),
            SizedBox(height: 16),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNovelsList(),
                  _buildAuthorDetails(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}