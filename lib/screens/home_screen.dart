import 'package:flutter/material.dart';
import '../widgets/banner_section.dart';
import '../widgets/horizontal_list_section.dart';
import '../services/data_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Audio Truyện 247'),
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
                _buildFullReadSection(),
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

  Widget _buildFullReadSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đọc full truyện và audio\nkhông giới hạn chỉ với',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            '55K',
            style: TextStyle(color: Colors.green, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '*Ấn vào đây',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
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
class CustomButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Đặt hướng cuộn ngang
      child: Row(
        children: [
          Container(
            width: 100,  // Tùy chỉnh độ rộng ở đây
            height: 40,  // Tùy chỉnh chiều cao ở đây
            child: _buildButton(
              icon: Icons.local_fire_department,
              label: 'Xu hướng',
              color: Colors.green,
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 120,  // Tùy chỉnh độ rộng ở đây
            height: 40,  // Tùy chỉnh chiều cao ở đây
            child: _buildButton(
              icon: Icons.book,
              label: 'Top truyện',
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 220,  // Tùy chỉnh độ rộng ở đây
            height: 40,  // Tùy chỉnh chiều cao ở đây
            child: _buildButton(
              icon: Icons.person,
              label: 'Người khác cũng đang nghe',
              color: Colors.grey[800]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
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
        foregroundColor: color == Colors.white ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      onPressed: () {
        // Add button action here
      },
    );
  }
}

