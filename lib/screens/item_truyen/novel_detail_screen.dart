import 'package:flutter/material.dart';

class NovelDetailScreen extends StatelessWidget {
  final Map<String, dynamic> novelData;

  const NovelDetailScreen({Key? key, required this.novelData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackbar(context, novelData['title'] ?? 'Unknown Title', novelData['author'] ?? 'Unknown Author');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(novelData['title'] ?? 'Novel Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImage(novelData['coverImage'] ?? ''),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          novelData['title'] ?? 'Unknown Title',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.bookmark_border),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Text(novelData['author'] ?? 'Unknown Author', style: TextStyle(fontSize: 16)),
                  Text('${novelData['chapterCount'] ?? 'Unknown'} Chương', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  _buildStatsRow(
                      novelData['readTime']?.toString() ?? 'Unknown',
                      (novelData['rating'] as num?)?.toDouble() ?? 0.0,
                      (novelData['likes'] as num?)?.toInt() ?? 0
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Về cuốn truyện này',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    novelData['description'] ?? 'No description available.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  _buildTags(novelData['tags'] as List<dynamic>? ?? []),
                  SizedBox(height: 24),
                  Text(
                    '${novelData['availableChapters'] ?? 'Unknown'} Chapters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _buildChapterList(novelData['chapters'] as List<dynamic>? ?? []),
                  SizedBox(height: 16),
                  _buildSimilarContent(novelData['similarNovels'] as List<dynamic>? ?? []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String title, String author) {
    final snackBar = SnackBar(
      content: Text('Title: $title\nAuthor: $author'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildCoverImage(String imageUrl) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 250,
              color: Colors.grey,
              child: Center(child: Text('Image not available')),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.black.withOpacity(0.7),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.book),
                    label: Text('Đọc tiếp'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.headphones),
                    label: Text('Nghe Tiếp'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(String readTime, double rating, int likes) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text(readTime, style: TextStyle(color: Colors.grey)),
        SizedBox(width: 16),
        Icon(Icons.star, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text(rating.toStringAsFixed(1), style: TextStyle(color: Colors.grey)),
        SizedBox(width: 16),
        Icon(Icons.thumb_up, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text('${likes}K', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildTags(List<dynamic> tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => _buildTag(tag.toString())).toList(),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(tag, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildChapterList(List<dynamic> chapters) {
    return Column(
      children: chapters.map((chapter) {
        final chapterData = chapter as Map<String, dynamic>;
        return _buildChapterItem(
          chapterData['number']?.toString() ?? 'Unknown',
          chapterData['title']?.toString() ?? 'Untitled',
          chapterData['isLocked'] as bool? ?? false,
        );
      }).toList(),
    );
  }

  Widget _buildChapterItem(String number, String title, bool isLocked) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            number,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isLocked)
                  Text(
                    'Đăng ký để mở khóa chương này',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          Icon(isLocked ? Icons.lock : Icons.play_arrow, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSimilarContent(List<dynamic> similarNovels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nội dung tương tự', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              child: Text('Tất cả >', style: TextStyle(color: Colors.blue)),
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: similarNovels.map((novel) {
              final novelData = novel as Map<String, dynamic>;
              return _buildSimilarItem(
                novelData['title']?.toString() ?? 'Untitled',
                novelData['author']?.toString() ?? 'Unknown Author',
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarItem(String title, String author) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(author, style: TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
