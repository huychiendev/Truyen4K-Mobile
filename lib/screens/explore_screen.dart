import 'package:flutter/material.dart';
import 'all_items_screen.dart'; // Đảm bảo import đúng file

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thể loại',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: ['Tiên Hiệp', 'Khoa Huyễn', 'Võng Du'].map((category) {
            return Chip(
              label: Text(category),
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),// search
              SizedBox(height: 20),
              _buildCategories(), // Thể loại
              SizedBox(height: 20),
              _buildRecommendations(), // Đề xuất
              SizedBox(height: 20),
              _buildSwordplay(), // Truyện Kiếm Hiệp
              SizedBox(height: 20),
              _buildNovel(), // Truyện Mới
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  // Thêm hàm _buildCategories


  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Khám Phá'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Tìm kiếm truyện, tác giả...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    List<dynamic> recommendationItems = [
      {'title': 'Truyện đề xuất 1', 'subtitle': 'Chi tiết 1'},
      {'title': 'Truyện đề xuất 2', 'subtitle': 'Chi tiết 2'},
      {'title': 'Truyện đề xuất 1', 'subtitle': 'Chi tiết 1'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đề xuất cho bạn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllItemsScreen(
                      items: recommendationItems,
                      category: 'Đề xuất',
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
        SizedBox(height: 10),
        _buildHorizontalList(recommendationItems),
      ],
    );
  }

  Widget _buildSwordplay() {
    List<dynamic> swordplayItems = [
      {'title': 'Kiếm hiệp 1', 'subtitle': 'Chi tiết 1'},
      {'title': 'Kiếm hiệp 2', 'subtitle': 'Chi tiết 2'},
      {'title': 'Kiếm hiệp 3', 'subtitle': 'Chi tiết 3'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Truyện Kiếm Hiệp',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllItemsScreen(
                      items: swordplayItems,
                      category: 'Truyện Kiếm Hiệp',
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
        SizedBox(height: 10),
        _buildHorizontalList(swordplayItems),
      ],
    );
  }

  Widget _buildNovel() {
    List<dynamic> novelItems = [
      {'title': 'Truyện mới 1', 'subtitle': 'Chi tiết 1'},
      {'title': 'Truyện mới 2', 'subtitle': 'Chi tiết 2'},
      {'title': 'Truyện mới 3', 'subtitle': 'Chi tiết 3'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Truyện Tu Tiên',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllItemsScreen(
                      items: novelItems,
                      category: 'Truyện Mới',
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
        SizedBox(height: 10),
        _buildHorizontalList(novelItems),
      ],
    );
  }

  Widget _buildHorizontalList(List<dynamic> items) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map<String, dynamic>;
          return Container(
            width: 120,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.red[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  color: Colors.pink,
                ),
                SizedBox(height: 5),
                Text(item['title'] ?? 'Title'),
              ],
            ),
          );
        },
      ),
    );
  }
}
