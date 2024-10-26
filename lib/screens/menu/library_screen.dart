import 'package:flutter/material.dart';
import '../../models/library_novel.dart';
import '../../services/novel_service.dart';
import '../menu/genre_novels_screen.dart';
import '../self_screen/register_screen/prime_screen.dart';
import 'library_controller.dart';
import '../item_truyen/view_screen/novel_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  final LibraryController _controller = LibraryController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller.initializeData();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _controller.refreshSavedNovels();
            break;
          case 1:
            _controller.refreshReadingProgressNovels();
            break;
          case 2:
            _controller.refreshCompletedNovels();
            break;
        }
      });
    }
  }

  Future<List<LibraryNovel>> _handleNullableFuture(
      Future<List<LibraryNovel>>? future) {
    return future ?? Future.value([]);
  }

  void _showMoreOptions(BuildContext context, LibraryNovel novel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => LibraryMoreOptionsMenu(
        novel: novel,
        onLibraryUpdated: () {
          _controller.refreshSavedNovels();
        },
      ),
    );
  }

  void _navigateToNovelDetail(LibraryNovel novel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NovelDetailScreen(slug: novel.slug),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text('Thư viện'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Truyện đã lưu'),
              Tab(text: 'Đang đọc'),
              Tab(text: 'Đã Đọc Xong'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            LibraryTabContent(
              future: _handleNullableFuture(_controller.savedNovelsFuture),
              refreshCallback: _controller.refreshSavedNovels,
              emptyMessage: 'Không tìm thấy truyện đã lưu.',
              onMoreTap: _showMoreOptions,
              onNovelTap: _navigateToNovelDetail,
            ),
            LibraryTabContent(
              future: _handleNullableFuture(_controller.readingProgressNovelsFuture),
              refreshCallback: _controller.refreshReadingProgressNovels,
              emptyMessage: 'Không tìm thấy truyện đang đọc.',
              onMoreTap: _showMoreOptions,
              onNovelTap: _navigateToNovelDetail,
            ),
            LibraryTabContent(
              future: _handleNullableFuture(_controller.completedNovelsFuture),
              refreshCallback: _controller.refreshCompletedNovels,
              emptyMessage: 'Không tìm thấy truyện đã đọc xong.',
              onMoreTap: _showMoreOptions,
              onNovelTap: _navigateToNovelDetail,
            ),
          ],
        ),
      ),
    );
  }
}

// Library Tab Content Widget
class LibraryTabContent extends StatelessWidget {
  final Future<List<LibraryNovel>> future;
  final VoidCallback refreshCallback;
  final String emptyMessage;
  final Function(BuildContext, LibraryNovel) onMoreTap;
  final Function(LibraryNovel) onNovelTap;

  const LibraryTabContent({
    Key? key,
    required this.future,
    required this.refreshCallback,
    required this.emptyMessage,
    required this.onMoreTap,
    required this.onNovelTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => refreshCallback(),
      child: FutureBuilder<List<LibraryNovel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(emptyMessage));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final novel = snapshot.data![index];
              return NovelListItem(
                novel: novel,
                onMoreTap: () => onMoreTap(context, novel),
                onNovelTap: () => onNovelTap(novel),
              );
            },
          );
        },
      ),
    );
  }
}

// Novel List Item Widget
class NovelListItem extends StatelessWidget {
  final LibraryNovel novel;
  final VoidCallback onMoreTap;
  final VoidCallback onNovelTap;

  const NovelListItem({
    Key? key,
    required this.novel,
    required this.onMoreTap,
    required this.onNovelTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNovelTap,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(novel.thumbnailImageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          novel.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          novel.subtitle,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          onPressed: onMoreTap,
        ),
      ),
    );
  }
}

// Library More Options Menu Widget
class LibraryMoreOptionsMenu extends StatelessWidget {
  final LibraryNovel novel;
  final VoidCallback? onLibraryUpdated;

  const LibraryMoreOptionsMenu({
    Key? key,
    required this.novel,
    this.onLibraryUpdated,
  }) : super(key: key);

  Future<void> _handleRemoveFromLibrary(BuildContext context) async {
    try {
      bool removed = await NovelService.toggleSave(novel.slug);
      if (removed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã bỏ lưu truyện khỏi thư viện')),
        );
        Navigator.pop(context);
        if (onLibraryUpdated != null) {
          onLibraryUpdated!();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi bỏ lưu truyện')),
      );
    }
  }

  void _navigateToGenre(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenreNovelsScreen(genre: novel.primaryGenre),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(novel.thumbnailImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        novel.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        novel.authorName,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[800], height: 1),
          _buildMenuItem(
            icon: Icons.remove_circle_outline,
            text: 'Hủy lưu truyện',
            onTap: () => _handleRemoveFromLibrary(context),
          ),
          _buildMenuItem(
            icon: Icons.category_outlined,
            text: 'Xem thể loại truyện',
            onTap: () => _navigateToGenre(context),
          ),
          _buildMenuItem(
            icon: Icons.workspace_premium,
            text: 'Nạp vip để nghe không quảng cáo',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PremiumScreen1(),
                ),
              );
            },
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}