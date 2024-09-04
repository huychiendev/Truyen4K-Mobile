import 'package:flutter/material.dart';
import '../widgets/circular_icon.dart';
import '../widgets/banner_section.dart';
import '../widgets/horizontal_list_section.dart';
import '../services/data_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      // Removed bottomNavigationBar from here
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
                actionText: 'Xem Tất Cả',
                items: section['items'] as List<dynamic>,
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