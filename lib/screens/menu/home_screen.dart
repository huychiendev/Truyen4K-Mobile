import 'package:apptruyenonline/screens/menu/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/general_widgets/banner_section.dart';
import '../item_truyen/all_items_screen.dart';
import '../item_truyen/view_screen/miniplayer.dart';
import '../item_truyen/view_screen/novel_detail_screen.dart';
import 'package:apptruyenonline/screens/item_truyen/view_screen/mobile_audio_player.dart';
import 'package:provider/provider.dart';

class DataService {
  static Future<Map<String, dynamic>> fetchData(String endpoint) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Không tìm thấy token');
      }

      final response = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Không thể tải dữ liệu');
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu: $e');
      return {'content': []};  // Trả về nội dung rỗng thay vì ném lỗi
    }
  }

  static Future<Map<String, dynamic>> fetchNewReleasedNovels() async {
    return fetchData('novels/new-released?page=0&size=100');
  }

  static Future<Map<String, dynamic>> fetchTrendingNovels() async {
    return fetchData('novels/trending?page=0&size=100');
  }

  static Future<Map<String, dynamic>> fetchTopReadNovels() async {
    return fetchData('novels/top-read?page=0&size=100');
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _HomeScreenContent();
  }
}

class _HomeScreenContent extends StatefulWidget {
  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadAllData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          'Audio Truyện 247',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading data: ${snapshot.error}'));
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
      bottomNavigationBar: Consumer<AudioPlayerProvider>(
        builder: (context, audioPlayerProvider, child) {
          return audioPlayerProvider.showMiniPlayer
              ? _buildMiniPlayer(context, audioPlayerProvider)
              : SizedBox.shrink();
        },
      ),
    );
  }


  Widget _buildBody(BuildContext context, Map<String, dynamic> data) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopSection(context, data['newReleased']['content'] as List<dynamic>?),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
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
                    onPlayTap: (novel) => _startPlayingNovel(context, novel),
                  ),
                  HorizontalListSection(
                    title: 'Truyện Đọc Nhiều Nhất',
                    items: data['topRead']['content'] as List<dynamic>,
                    category: 'Truyện Đọc Nhiều Nhất',
                    onPlayTap: (novel) => _startPlayingNovel(context, novel),
                  ),
                  HorizontalListSection(
                    title: 'Truyện Mới Cập Nhật',
                    items: data['newReleased']['content'] as List<dynamic>,
                    category: 'Truyện Mới Cập Nhật',
                    onPlayTap: (novel) => _startPlayingNovel(context, novel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startPlayingNovel(BuildContext context, Map<String, dynamic> novel) {
    context.read<AudioPlayerProvider>().updatePlayerState(
      showMiniPlayer: true,
      currentTitle: novel['title'],
      currentArtist: 'Chương 1',
      currentImageUrl: novel['thumbnailImageUrl'],
      currentSlug: novel['slug'],
      isPlaying: true,
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
}

Widget _buildTopSection(BuildContext context, List<dynamic>? titles) {
  if (titles == null || titles.isEmpty) return SizedBox.shrink();
  return Container(
    height: 100,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: titles.length,
      itemBuilder: (context, index) {
        final title = titles[index];
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
      },
    ),
  );
}


class CircularIcon extends StatelessWidget {
  final String label;
  final String imageUrl;

  const CircularIcon({Key? key, required this.label, required this.imageUrl})
      : super(key: key);

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
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
  final Function(Map<String, dynamic>) onPlayTap;

  const HorizontalListSection({
    Key? key,
    required this.title,
    required this.items,
    required this.category,
    required this.onPlayTap,
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
            Stack(
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
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: IconButton(
                    icon: Icon(Icons.play_circle_filled, color: Colors.white),
                    onPressed: () => onPlayTap(item),
                  ),
                ),
              ],
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