import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/banner_section.dart';
import '../item_truyen/all_items_screen.dart';
import '../item_truyen/novel_detail_screen.dart';

// DataService
class DataService {
  static Future<Map<String, dynamic>> fetchNewReleasedNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(
          'http://14.225.207.58:9898/api/novels/new-released?page=0&size=10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load new released novels');
    }
  }

  static Future<Map<String, dynamic>> fetchTrendingNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/novels/trending?page=0&size=10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load trending novels');
    }
  }

  static Future<Map<String, dynamic>> fetchTopReadNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/novels/top-read?page=0&size=10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load top-read novels');
    }
  }
}

// HomeScreen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('auth_token');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Token của bạn'),
                  content: Text(token ?? 'Không tìm thấy token!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Đóng'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Audio Truyện 247'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading data: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // Print the data
              print('New Released Novels: ${snapshot.data!['newReleased']}');
              print('Trending Novels: ${snapshot.data!['trending']}');
              print('Top Read Novels: ${snapshot.data!['topRead']}');
              return _buildBody(context, snapshot.data!);
            } else {
              return Center(child: Text('No data available'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _loadAllData() async {
    final newReleasedNovels = await DataService.fetchNewReleasedNovels();
    final trendingNovels = await DataService.fetchTrendingNovels();
    final topReadNovels = await DataService.fetchTopReadNovels();

    return {
      'newReleased': newReleasedNovels,
      'trending': trendingNovels,
      'topRead': topReadNovels,
    };
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(context, data['newReleased']['content'] as List<dynamic>?),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButtons(data: data),
                SizedBox(height: 16),
                BannerSection(
                  bannerData: {
                    'images': [
                      'assets/bn1.jpg',
                      'assets/bn2.jpg',
                      'assets/bn3.jpg',
                      'assets/bn4.jpg',
                      'assets/bn5.jpg',
                      'assets/bn6.jpg',
                    ],
                  },
                ),
                SizedBox(height: 16),
                HorizontalListSection(
                  title: 'Xu hướng',
                  items: data['trending']['content'] as List<dynamic>,
                  category: 'Xu hướng',
                ),
                HorizontalListSection(
                  title: 'Truyện Đọc Nhiều Nhất',
                  items: data['topRead']['content'] as List<dynamic>,
                  category: 'Truyện Đọc Nhiều Nhất',
                ),
                HorizontalListSection(
                  title: 'Truyện Mới Cập Nhật',
                  items: data['newReleased']['content'] as List<dynamic>,
                  category: 'Truyện Mới Cập Nhật',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, List<dynamic>? titles) {
    if (titles == null || titles.isEmpty) return SizedBox.shrink();
    return Container(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: titles.map((title) {
            final label = title['title'] as String? ?? 'No Title';
            final imageUrl = title['thumbnailImageUrl'] as String? ?? 'https://via.placeholder.com/60';
            final slug = title['slug'] as String? ?? '';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovelDetailScreen(slug: slug),
                  ),
                );
              },
              child: CircularIcon(
                label: label,
                imageUrl: imageUrl,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// CircularIcon
class CircularIcon extends StatelessWidget {
  final String label;
  final String imageUrl;

  const CircularIcon({Key? key, required this.label, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[800],
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: 60,
              child: Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.white),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButtons extends StatefulWidget {
  final Map<String, dynamic> data;

  const CustomButtons({Key? key, required this.data}) : super(key: key);

  @override
  _CustomButtonsState createState() => _CustomButtonsState();
}

class _CustomButtonsState extends State<CustomButtons> {
  int? selectedButtonIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildButton(
            index: 0,
            icon: Icons.local_fire_department,
            label: 'Xu hướng',
          ),
          SizedBox(width: 10),
          _buildButton(
            index: 1,
            icon: Icons.book,
            label: 'Truyện đọc nhiều nhất',
          ),
          SizedBox(width: 10),
          _buildButton(
            index: 2,
            icon: Icons.person,
            label: 'Truyện mới cập nhật',
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedButtonIndex == index;
    return ElevatedButton.icon(
      icon: Icon(icon, color: isSelected ? Colors.black : Colors.white, size: 18),
      label: Text(
        label,
        style: TextStyle(
            color: isSelected ? Colors.black : Colors.white, fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      onPressed: () {
        setState(() {
          selectedButtonIndex = index;
        });

        // Điều hướng đến AllItemsScreen với danh mục tương ứng
        String category;
        List<dynamic> items;
        switch (index) {
          case 0:
            category = 'Xu hướng';
            items = widget.data['trending']['content'];
            break;
          case 1:
            category = 'Truyện đọc nhiều nhất';
            items = widget.data['topRead']['content'];
            break;
          case 2:
            category = 'Truyện mới cập nhật';
            items = widget.data['newReleased']['content'];
            break;
          default:
            return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllItemsScreen(
              items: items,
              category: category,
            ),
          ),
        );
      },
    );
  }
}

class HorizontalListSection extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final String category;

  const HorizontalListSection({
    Key? key,
    required this.title,
    required this.items,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  // Điều hướng tới màn hình "Xem Tất Cả" và truyền cả items lẫn category
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllItemsScreen(
                        items: items,
                        category: category, // Truyền danh mục
                      ),
                    ),
                  );
                },
                child: Text(
                  'Xem Tất Cả',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items
                  .map((item) => _buildHorizontalListItem(context, item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListItem(
      BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NovelDetailScreen(slug: item['slug']),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item['thumbnailImageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 120,
              child: Text(
                item['title'] ?? 'Title',
                style: TextStyle(fontSize: 14, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
