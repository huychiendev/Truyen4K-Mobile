import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Audio Truyện 247'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error loading data'));
              } else if (snapshot.hasData) {
                return _buildBody(context, snapshot.data!);
              } else {
                return Center(child: Text('No data available'));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Future<Map<String, dynamic>> _loadData() async {
    final jsonString = await rootBundle.loadString('assets/mock_data.json');
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            _buildTopSection(data['circularIcons'] as List<dynamic>?),

            // Middle Section - Banner
            _buildBanner(data['banner'] as Map<String, dynamic>?),

            // Sections
            for (var section in data['sections'] as List<dynamic>)
              _buildHorizontalListSection(section['title'] as String, 'Xem Tất Cả', section['items'] as List<dynamic>),
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
        children: titles.map((title) => _buildCircularIcon(title as String)).toList(),
      ),
    );
  }

  Widget _buildCircularIcon(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.book, color: Colors.white), // Placeholder icon
          ),
          SizedBox(height: 8),
          Container(
            width: 60,
            child: Text(
              label,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(Map<String, dynamic>? bannerData) {
    if (bannerData == null) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF323860),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Đọc full truyện và audio\nkhông giới hạn chỉ với",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "55K",
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
                ),
                Spacer(),
                Container(
                  width: 180,
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBookStack(bannerData['images'][0], bannerData['images'][1], 0.8),
                      _buildBookStack(bannerData['images'][2], bannerData['images'][3], 0.9),
                      _buildBookStack(bannerData['images'][4], bannerData['images'][5], 1.0),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "*Terms & conditions apply",
              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookStack(String topImageUrl, String bottomImageUrl, double scaleFactor) {
    return Container(
      width: 55 * scaleFactor,
      height: 120 * scaleFactor,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildBookCover(bottomImageUrl, 50 * scaleFactor, 75 * scaleFactor),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _buildBookCover(topImageUrl, 50 * scaleFactor, 75 * scaleFactor),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCover(String imageUrl, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListSection(String title, String actionText, List<dynamic> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(actionText, style: TextStyle(color: Colors.green)),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items.map((item) => _buildHorizontalListItem(item as Map<String, dynamic>)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 8),
          Text(
            item['title'] as String? ?? '',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            item['subtitle'] as String? ?? '',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Khám phá'),
        BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Thư viện'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tôi'),
      ],
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
    );
  }
}
