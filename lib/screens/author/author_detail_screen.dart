import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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
  Map<String, dynamic>? authorData;
  List<dynamic> authorNovels = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadAuthorData();
  }

  Future<void> _loadAuthorData() async {
    try {
      setState(() => isLoading = true);

      // Fetch author details
      final authorResponse = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/authors/'),
      );

      // Fetch author's novels
      final novelsResponse = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/novels/auth/my-novels?authorName=${widget.authorName}'),
      );

      if (authorResponse.statusCode == 200 && novelsResponse.statusCode == 200) {
        final List<dynamic> authors = json.decode(utf8.decode(authorResponse.bodyBytes));
        final authorInfo = authors.firstWhere(
              (author) => author['name'] == widget.authorName,
          orElse: () => null,
        );

        final novelsData = json.decode(utf8.decode(novelsResponse.bodyBytes));

        setState(() {
          authorData = authorInfo;
          authorNovels = novelsData['content'] as List<dynamic>;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load author data');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
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
        onRefresh: _loadAuthorData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildAuthorInfo(),
              _buildStats(),
              _buildNovelsList(),
            ],
          ),
        ),
      ),
    );
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
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorData?['name'] ?? widget.authorName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis, // Thêm dòng này
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                        SizedBox(width: 8),
                        Expanded( // Thêm Expanded ở đây
                          child: Text(
                            'Tham gia: ${_formatDate(authorData?['dob'] ?? 'Chưa có thông tin')}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis, // Thêm dòng này
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Text(
                  'ID: ${authorData?['id'] ?? 'N/A'}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (authorData == null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Đang tải thông tin tác giả...',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatItem('Tác phẩm', authorNovels.length),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildNovelsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: authorNovels.length,
      itemBuilder: (context, index) {
        final novel = authorNovels[index];
        return Card(
          color: Colors.grey[900],
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                novel['thumbnailImageUrl'] ?? 'https://via.placeholder.com/60x90',
                width: 60,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              novel['title'] ?? 'Không có tiêu đề',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  'Số chương: ${novel['totalChapters']}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'Lượt đọc: ${novel['readCounts']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
              // Navigate to NovelDetailScreen
            },
          ),
        );
      },
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Chưa có thông tin'; // Trả về thông báo khi dob là null hoặc rỗng
    }
    try {
      final date = DateTime.parse(dateString); // Thử phân tích chuỗi ngày
      return DateFormat('dd/MM/yyyy').format(date); // Trả về định dạng ngày
    } catch (e) {
      return 'Ngày không hợp lệ'; // Trường hợp có lỗi khi phân tích ngày
    }
  }

}