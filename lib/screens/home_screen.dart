import 'package:flutter/material.dart';
import '../widgets/banner_section.dart';
import '../widgets/horizontal_list_section.dart';
import '../services/data_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Truyện 247'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/avt.png'), // Path to your user image
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: DataService.loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Lỗi khi tải dữ liệu'));
            } else if (snapshot.hasData) {
              return _buildBody(context, snapshot.data!);
            } else {
              return Center(child: Text('Không có dữ liệu'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopSection(data['circularIcons'] as List<dynamic>?),
            BannerSection(bannerData: data['banner'] as Map<String, dynamic>?),
            for (var section in data['sections'] as List<dynamic>)
              HorizontalListSection(
                title: section['title'] as String,
                items: section['items'] as List<dynamic>,
                category: section['title'] as String, // Truyền danh mục dựa vào title
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(List<dynamic>? titles) {
    if (titles == null || titles.isEmpty) return SizedBox.shrink();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: titles.map((title) => CircularIcon(label: title as String)).toList(),
      ),
    );
  }
}

class CircularIcon extends StatelessWidget {
  final String label;

  const CircularIcon({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue, // Màu nền của icon tròn
            ),
            child: Center(
              child: Icon(Icons.star, color: Colors.white), // Hoặc thay đổi icon khác
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}