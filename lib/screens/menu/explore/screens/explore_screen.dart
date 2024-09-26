import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptruyenonline/screens/menu/audio_player_provider.dart';
import 'package:apptruyenonline/screens/item_truyen/all_items_screen.dart';
import 'package:apptruyenonline/screens/item_truyen/view_screen/novel_detail_screen.dart';
import 'package:apptruyenonline/screens/item_truyen/view_screen/mobile_audio_player.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chip.dart';
import '../widgets/horizontal_novel_list.dart';
import '../models/novel.dart';
import '../services/explore_service.dart';
import '../controllers/explore_controller.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ExploreController _controller = ExploreController();
  final ExploreService _service = ExploreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //SearchBar(),
                  SizedBox(height: 20),
                  _buildCategories(),
                  SizedBox(height: 20),
                  _buildRecommendations(),
                  SizedBox(height: 20),
                  _buildSwordplay(),
                  SizedBox(height: 20),
                  _buildNovel(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Consumer<AudioPlayerProvider>(
            builder: (context, audioPlayerProvider, child) {
              return audioPlayerProvider.showMiniPlayer
                  ? Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildMiniPlayer(context, audioPlayerProvider),
              )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

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
            return CategoryChip(label: category);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return FutureBuilder<List<Novel>>(
      future: _service.fetchTopReadNovels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return _buildNovelSection(
            title: 'Đề xuất cho bạn',
            novels: snapshot.data!,
            onViewAll: () => _navigateToAllItems(snapshot.data!, 'Đề xuất'),
          );
        } else {
          return Text('No novels found.');
        }
      },
    );
  }

  Widget _buildSwordplay() {
    return FutureBuilder<List<Novel>>(
      future: _service.fetchNovelsByGenre([13]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return _buildNovelSection(
            title: 'Truyện Kiếm Hiệp',
            novels: snapshot.data!,
            onViewAll: () => _navigateToAllItems(snapshot.data!, 'Truyện Kiếm Hiệp'),
          );
        } else {
          return Text('No novels found.');
        }
      },
    );
  }

  Widget _buildNovel() {
    return FutureBuilder<List<Novel>>(
      future: _service.fetchNovelsByGenre([12]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return _buildNovelSection(
            title: 'Truyện Tu Tiên',
            novels: snapshot.data!,
            onViewAll: () => _navigateToAllItems(snapshot.data!, 'Truyện Tu Tiên'),
          );
        } else {
          return Text('No novels found.');
        }
      },
    );
  }

  Widget _buildNovelSection({required String title, required List<Novel> novels, required VoidCallback onViewAll}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextButton(
              onPressed: onViewAll,
              child: Text('Xem Tất Cả', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
        SizedBox(height: 10),
        HorizontalNovelList(
          novels: novels,
          onNovelTap: _navigateToNovelDetail,
          onPlayTap: _startPlayingNovel,
        ),
      ],
    );
  }

  void _navigateToAllItems(List<Novel> novels, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllItemsScreen(
          items: novels
              .map((novel) => {
            'slug': novel.slug,
            'title': novel.title,
            'authorName': novel.description,
            'thumbnailImageUrl': novel.thumbnailImageUrl,
            'averageRatings': novel.averageRatings,
          })
              .toList(),
          category: category,
        ),
      ),
    );
  }

  void _navigateToNovelDetail(Novel novel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NovelDetailScreen(slug: novel.slug),
      ),
    );
  }

  void _startPlayingNovel(Novel novel) {
    _controller.startPlayingNovel(novel, context);
  }

  Widget _buildMiniPlayer(BuildContext context, AudioPlayerProvider audioPlayerProvider) {
    return _controller.buildMiniPlayer(context, audioPlayerProvider);
  }
}