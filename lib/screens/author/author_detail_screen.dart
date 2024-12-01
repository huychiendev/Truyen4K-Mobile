import 'package:flutter/material.dart';
import '../../models/ProfileModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  bool _isFollowing = false;
  int _followerCount = 0;
  List<dynamic> _authorNovels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAuthorData();
  }

  Future<void> _loadAuthorData() async {
    setState(() => _isLoading = true);
    try {
      // Fetch author's novels
      final novelsResponse = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/novels/auth/my-novels?authorName=${widget.authorName}'),
      );

      // Fetch followers count
      final followersResponse = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/followers/${widget.authorId}'),
      );

      if (novelsResponse.statusCode == 200) {
        setState(() {
          _authorNovels = json.decode(utf8.decode(novelsResponse.bodyBytes));
        });
      }

      if (followersResponse.statusCode == 200) {
        final followers = json.decode(followersResponse.body);
        setState(() {
          _followerCount = followers.length;
        });
      }
    } catch (e) {
      print('Error loading author data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFollow() async {
    final endpoint = _isFollowing ? 'unfollow' : 'follow';
    try {
      final response = await http.post(
        Uri.parse('http://14.225.207.58:9898/api/v1/$endpoint/author?currentUsername=admin&authorId=${widget.authorId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isFollowing = !_isFollowing;
          _followerCount += _isFollowing ? 1 : -1;
        });
      }
    } catch (e) {
      print('Error toggling follow: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Thông tin tác giả'),
        actions: [
          IconButton(
            icon: Icon(_isFollowing ? Icons.person_remove : Icons.person_add),
            onPressed: _toggleFollow,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAuthorHeader(),
            _buildStats(),
            _buildNovelsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.authorName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tác giả',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Tác phẩm', _authorNovels.length.toString()),
          _buildStatItem('Người theo dõi', _followerCount.toString()),
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildNovelsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Tác phẩm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _authorNovels.length,
          itemBuilder: (context, index) {
            final novel = _authorNovels[index];
            return ListTile(
              leading: Container(
                width: 50,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(novel['thumbnailImageUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                novel['title'],
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${novel['totalChapters']} chương',
                style: TextStyle(color: Colors.grey),
              ),
            );
          },
        ),
      ],
    );
  }
}