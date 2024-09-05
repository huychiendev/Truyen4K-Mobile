import 'package:flutter/material.dart';

class NovelDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImage(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tận Thế Thập Phòng: Phòng Ngự Của Ta Thập Quá Mức Cần Thân!',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.bookmark_border),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Text('Nhữ Hữu Thần Trụ', style: TextStyle(fontSize: 16)),
                  Text('1900 Chương', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  _buildStatsRow(),
                  SizedBox(height: 16),
                  Text(
                    'Về cuốn truyện này',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ngày tận thế tới, mỗi người trưởng thành đều phải tiến vào tháp phòng thế giới ngăn cản Zombie xâm lấn...\nLuôn luôn cẩn thận Lục Vân thức tỉnh duy nhất thiên phú như giám trên bảng mộng, cũng dẫn đến hắn tháp phòng ngự đêu đi theo bất đẩu cẩn thận...',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  _buildTags(),
                  SizedBox(height: 24),
                  Text(
                    '56 Chapters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _buildChapterList(),
                  SizedBox(height: 16),
                  _buildSimilarContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    return Stack(
      children: [
        Image.asset(
          'assets/300.jpg',
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
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
                      backgroundColor: Colors.blue
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
                      backgroundColor: Colors.grey[700]
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

  Widget _buildStatsRow() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text('18 phút', style: TextStyle(color: Colors.grey)),
        SizedBox(width: 16),
        Icon(Icons.star, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text('4.1', style: TextStyle(color: Colors.grey)),
        SizedBox(width: 16),
        Icon(Icons.thumb_up, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text('106.2K', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildTag('Cờ tích'),
        _buildTag('Đông Phương Huyền Huyễn'),
        _buildTag('Xuyên Qua'),
        _buildTag('Khoa Huyễn'),
      ],
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

  Widget _buildChapterList() {
    return Column(
      children: [
        _buildChapterItem('01', 'Thích cờ bạc chả, xã hội muội, chính nghĩa hán!', false),
        _buildChapterItem('02', 'Nhập môn tháp giới, cẩn thận thăng cấp', true),
        _buildChapterItem('03', 'Phàn liệt tiên cung xuyên thấu tiên', true),
        ListTile(
          title: Text('Tóm tắt', style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.lock, color: Colors.grey),
        ),
      ],
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
                    'Đăng ký để mở khóa tất cả 2 ý tưởng chính tử...',
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

  Widget _buildSimilarContent() {
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
            children: [
              _buildSimilarItem('Futurama', 'Bach Y Thiết Tương'),
              _buildSimilarItem('Explore your create...', 'Trung ha nguyet ban'),
              _buildSimilarItem('Hoàng Hôn Phần q', 'Nhữ Hữu Thần Trụ'),
            ],
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
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(author, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}