import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptruyenonline/screens/menu/audio_player_provider.dart';
import 'package:apptruyenonline/screens/item_truyen/all_items_screen.dart';
import 'package:apptruyenonline/screens/item_truyen/view_screen/novel_detail_screen.dart';
import '../../widgets/general_widgets/category_chip.dart';
import '../../../../services/explore_service.dart';
import '../../widgets/novel_widgets/horizontal_novel_list.dart';
import 'explore_controller.dart';
import '../../models/novel_model.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ExploreController _controller = ExploreController();
  final ExploreService _service = ExploreService();
  List<String> genres = [];
  bool isLoading = true;
  String? error;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  Future<void> _fetchGenres() async {
    try {
      List<String> fetchedGenres = await _service.fetchGenres();
      setState(() {
        genres = fetchedGenres;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải thể loại: $e')),
      );
    }
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return;

    try {
      List<Novel> authorResults = await _service.searchNovelsByAuthor(query);
      List<Novel> titleResults = await _service.searchNovelsByTitle(query);

      if (authorResults.isEmpty && titleResults.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không tìm thấy kết quả')),
        );
      } else {
        _showSearchResults(authorResults, titleResults);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy kết quả')),
      );
    }
  }

  void _showSearchResults(List<Novel> authorResults, List<Novel> titleResults) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.black),
          child: AlertDialog(
            title:
            Text('Kết quả tìm kiếm', style: TextStyle(color: Colors.green)),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildResultSection('Theo tác giả', authorResults),
                  SizedBox(height: 16),
                  _buildResultSection('Theo tiêu đề', titleResults),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Đóng', style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultSection(String title, List<Novel> novels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(height: 8),
        novels.isEmpty
            ? Text('Không tìm thấy kết quả',
            style: TextStyle(color: Colors.white))
            : Column(
          children: novels
              .take(3)
              .map((novel) => _buildNovelItem(novel))
              .toList(),
        ),
        if (novels.length > 3)
          TextButton(
            child: Text('Xem thêm', style: TextStyle(color: Colors.blueAccent)),
            onPressed: () {
              _navigateToAllItems(novels, title);
            },
          ),
      ],
    );
  }

  Widget _buildNovelItem(Novel novel) {
    return ListTile(
      leading: Image.network(novel.thumbnailImageUrl,
          width: 50, height: 75, fit: BoxFit.cover),
      title: Text(novel.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white)),
      subtitle: Text(novel.authorName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.of(context).pop();
        _navigateToNovelDetail(novel);
      },
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
      controller: _searchController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Tìm kiếm truyện...',
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: (value) {
        _performSearch(value);
      },
    );
  }

  Widget _buildCategories() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Text('Error: $error', style: TextStyle(color: Colors.red));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thể loại',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: genres.map((category) {
            return CategoryChip(label: category);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return FutureBuilder<List<Novel>>(
      future: _service.fetchRecommendations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Không thể tải đề xuất',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: Icon(Icons.refresh, color: Colors.green),
                    label: Text(
                      'Thử lại',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return _buildNovelSection(
            title: 'Đề xuất cho bạn',
            novels: snapshot.data!,
            onViewAll: () => _navigateToAllItems(snapshot.data!, 'Đề xuất'),
          );
        } else {
          return Container(
            height: 200,
            child: Center(
              child: Text(
                'Chưa có truyện đề xuất',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
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
            onViewAll: () =>
                _navigateToAllItems(snapshot.data!, 'Truyện Kiếm Hiệp'),
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
            onViewAll: () =>
                _navigateToAllItems(snapshot.data!, 'Truyện Tu Tiên'),
          );
        } else {
          return Text('No novels found.');
        }
      },
    );
  }

  Widget _buildNovelSection(
      {required String title,
        required List<Novel> novels,
        required VoidCallback onViewAll}) {
    return Column(
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

  Widget _buildMiniPlayer(
      BuildContext context, AudioPlayerProvider audioPlayerProvider) {
    return _controller.buildMiniPlayer(context, audioPlayerProvider);
  }
}