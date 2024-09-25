import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptruyenonline/screens/menu/audio_player_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../item_truyen/all_items_screen.dart';
import '../item_truyen/view_screen/novel_detail_screen.dart';
import '../item_truyen/view_screen/mobile_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptruyenonline/screens/item_truyen/view_screen/miniplayer.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

const Map<int, String> genreMap = {
  7: 'Tiên Hiệp',
  8: 'Đồng Nhân',
  9: 'Kiếm Hiệp',
  10: 'Hiện Đại Ngôn Tình',
  11: 'Võng Du',
  12: 'Đô Thị',
  13: 'Huyền Huyễn',
  14: 'Dã Sử',
};

class _ExploreScreenState extends State<ExploreScreen> {
  Future<List<Novel>> fetchTopReadNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/novels/top-read?page=0&size=10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['content'];
      return data.map((json) => Novel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load novels');
    }
  }

  Future<List<Novel>> fetchNovelsByGenre(List<int> genreIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/novels/filter-by-genre?genreIds=${genreIds.join(",")}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['content'];
      return data.map((json) => Novel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load novels');
    }
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
            return Chip(
              label: Text(category),
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
      ],
    );
  }

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
                  _buildSearchBar(),
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

  Widget _buildMiniPlayer(BuildContext context, AudioPlayerProvider audioPlayerProvider) {
    return Dismissible(
      key: Key('mini-player'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        audioPlayerProvider.updatePlayerState(showMiniPlayer: false);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(Icons.close, color: Colors.white),
      ),
      child: MiniPlayer(
        slug: audioPlayerProvider.currentSlug,
        chapterNo: 1,
        title: audioPlayerProvider.currentTitle,
        artist: audioPlayerProvider.currentArtist,
        imageUrl: audioPlayerProvider.currentImageUrl,
        isPlaying: audioPlayerProvider.isPlaying,
        onTap: () => _onMiniPlayerTap(context, audioPlayerProvider),
        onPlayPause: () {
          audioPlayerProvider.updatePlayerState(
            isPlaying: !audioPlayerProvider.isPlaying,
          );
        },
        onNext: () {
          // Handle next track
        },
        onDismiss: () {
          audioPlayerProvider.updatePlayerState(showMiniPlayer: false);
        },
      ),
    );
  }

  void _startPlayingNovel(Novel novel) {
    context.read<AudioPlayerProvider>().updatePlayerState(
      showMiniPlayer: true,
      currentTitle: novel.title,
      currentArtist: 'Chương 1',
      currentImageUrl: novel.thumbnailImageUrl,
      currentSlug: novel.slug,
      isPlaying: true,
    );
  }

  void _onMiniPlayerTap(BuildContext context, AudioPlayerProvider audioPlayerProvider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileAudioPlayer(
          slug: audioPlayerProvider.currentSlug,
          chapterNo: 1,
          novelName: audioPlayerProvider.currentTitle,
          thumbnailImageUrl: audioPlayerProvider.currentImageUrl,
        ),
      ),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        audioPlayerProvider.updatePlayerState(
          showMiniPlayer: result['showMiniPlayer'] ?? false,
          currentTitle: result['currentNovelName'] ?? audioPlayerProvider.currentTitle,
          currentArtist: 'Chương ${result['currentChapter'] ?? '1'}',
          isPlaying: result['isPlaying'] ?? audioPlayerProvider.isPlaying,
        );
      }
    });
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

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Tìm kiếm truyện, tác giả...',
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.search, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildRecommendations() {
    return FutureBuilder<List<Novel>>(
      future: fetchTopReadNovels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Novel> novels = snapshot.data!;
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
                            items: novels
                                .map((novel) => {
                              'slug': novel.slug,
                              'title': novel.title,
                              'authorName': novel.description,
                              'thumbnailImageUrl': novel.thumbnailImageUrl,
                              'averageRatings': novel.averageRatings,
                            })
                                .toList(),
                            category: 'Đề xuất',
                          ),
                        ),
                      );
                    },
                    child: Text('Xem Tất Cả', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildHorizontalList(context, novels),
            ],
          );
        } else {
          return Text('No novels found.');
        }
      },
    );
  }

  Widget _buildSwordplay() {
    return FutureBuilder<List<Novel>>(
      future: fetchNovelsByGenre([13]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Novel> novels = snapshot.data!;
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
                            items: novels
                                .map((novel) => {
                              'slug': novel.slug,
                              'title': novel.title,
                              'authorName': novel.description,
                              'thumbnailImageUrl': novel.thumbnailImageUrl,
                              'averageRatings': novel.averageRatings,
                            })
                                .toList(),
                            category: 'Truyện Kiếm Hiệp',
                          ),
                        ),
                      );
                    },
                    child: Text('Xem Tất Cả', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildHorizontalList(context, novels),
            ],
          );
        } else {
          return Text('No novels found.');
        }
      },
    );
  }

  Widget _buildNovel() {
    return FutureBuilder<List<Novel>>(
      future: fetchNovelsByGenre([12]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Novel> novels = snapshot.data!;
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
                            items: novels
                                .map((novel) => {
                              'slug': novel.slug,
                              'title': novel.title,
                              'authorName': novel.description,
                              'thumbnailImageUrl': novel.thumbnailImageUrl,
                              'averageRatings': novel.averageRatings,
                            })
                                .toList(),
                            category: 'Truyện Tu Tiên',
                          ),
                        ),
                      );
                    },
                    child: Text('Xem Tất Cả', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildHorizontalList(context, novels),
            ],
          );
        } else {
          return Text('No novels found.');
        }
      },
    );
  }

  Widget _buildHorizontalList(BuildContext context, List<Novel> novels) {
    return Container(
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
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
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
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: IconButton(
                          icon: Icon(Icons.play_circle_filled, color: Colors.white),
                          onPressed: () => _startPlayingNovel(novel),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 120,
                    child: Text(
                      novel.title,
                      style: TextStyle(fontSize: 14, color: Colors.white),
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
    );
  }
}

class Novel {
  final String slug;
  final String title;
  final String description;
  final String thumbnailImageUrl;
  final double averageRatings;

  Novel({
    required this.slug,
    required this.title,
    required this.description,
    required this.thumbnailImageUrl,
    required this.averageRatings,
  });

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      slug: json['slug'],
      title: json['title'],
      description: json['description'],
      thumbnailImageUrl: json['thumbnailImageUrl'],
      averageRatings: json['averageRatings'],
    );
  }
}