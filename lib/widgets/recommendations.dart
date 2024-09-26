import 'package:flutter/material.dart';
import '../models/novel.dart';
import '../screens/item_truyen/all_items_screen.dart';
import '../screens/item_truyen/view_screen/novel_detail_screen.dart';
import '../services/novel_service.dart';

class Recommendations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Novel>>(
      future: NovelService.fetchTopReadNovels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white)));
        } else if (snapshot.hasData) {
          List<Novel> novels = snapshot.data!;
          List<Map<String, dynamic>> novelMaps = novels.map((novel) => novel.toMap()).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Đề xuất cho bạn',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllItemsScreen(items: novelMaps, category: 'Đề xuất'),
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
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: novels.length,
                  itemBuilder: (context, index) {
                    final novel = novels[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NovelDetailScreen(slug: novel.slug),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(novel.thumbnailImageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 120,
                              child: Text(
                                novel.title,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(
              child: Text('No novels found.',
                  style: TextStyle(color: Colors.white)));
        }
      },
    );
  }
}