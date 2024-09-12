import 'package:flutter/material.dart';
import '../../widgets/banner_section.dart';
import '../../widgets/horizontal_list_section.dart';
import '../../services/data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            // Lấy token từ SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('auth_token');

            // Hiển thị token trong AlertDialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Token của bạn'),
                  content: Text(token ?? 'Không tìm thấy token!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
        future: DataService.loadData(),
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
    );
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(data['circularIcons'] as List<dynamic>?),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButtons(),
                SizedBox(height: 16),
                BannerSection(  // Replaced with BannerSection
                  bannerData: {
                    'images': [
                      'assets/300.jpg',
                      'assets/300.jpg',
                      'assets/300.jpg',
                      'assets/300.jpg',
                      'assets/300.jpg',
                      'assets/300.jpg',
                    ],
                  },
                ),
                SizedBox(height: 16),
                for (var section in data['sections'] as List<dynamic>)
                  HorizontalListSection(
                    title: section['title'] as String,
                    items: section['items'] as List<dynamic>,
                    category: section['title'] as String,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(List<dynamic>? titles) {
    if (titles == null || titles.isEmpty) return SizedBox.shrink();
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[800],
            ),
            child: Center(
              child: Icon(Icons.book, color: Colors.white),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CustomButtons extends StatefulWidget {
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
          Container(
            width: 100,
            height: 40,
            child: _buildButton(
              index: 0,
              icon: Icons.local_fire_department,
              label: 'Xu hướng',
              color: selectedButtonIndex == 0 ? Colors.green : Colors.grey[800]!,
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 120,
            height: 40,
            child: _buildButton(
              index: 1,
              icon: Icons.book,
              label: 'Top truyện',
              color: selectedButtonIndex == 1 ? Colors.green : Colors.grey[800]!,
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 220,
            height: 40,
            child: _buildButton(
              index: 2,
              icon: Icons.person,
              label: 'Người khác cũng đang nghe',
              color: selectedButtonIndex == 2 ? Colors.green : Colors.grey[800]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required int index,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: color == Colors.white ? Colors.black : Colors.white, size: 18),
      label: Text(
        label,
        style: TextStyle(color: color == Colors.white ? Colors.black : Colors.white, fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      onPressed: () {
        setState(() {
          selectedButtonIndex = index;
        });
      },
    );
  }
}
