// library_screen.dart
import 'package:apptruyenonline/screens/self_screen/register_screen/prime_screen.dart';
import 'package:flutter/material.dart';
import '../../widgets/library_widgets/library_tab.dart';
import 'library_controller.dart';
import '../../models/library_novel.dart';

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
      builder: (context) => LibraryMoreOptionsMenu(novel: novel),
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
            ),
            LibraryTabContent(
              future: _handleNullableFuture(_controller.readingProgressNovelsFuture),
              refreshCallback: _controller.refreshReadingProgressNovels,
              emptyMessage: 'Không tìm thấy truyện đang đọc.',
              onMoreTap: _showMoreOptions,
            ),
            LibraryTabContent(
              future: _handleNullableFuture(_controller.completedNovelsFuture),
              refreshCallback: _controller.refreshCompletedNovels,
              emptyMessage: 'Không tìm thấy truyện đã đọc xong.',
              onMoreTap: _showMoreOptions,
            ),
          ],
        ),
      ),
    );
  }
}

class LibraryTabContent extends StatelessWidget {
  final Future<List<LibraryNovel>> future;
  final VoidCallback refreshCallback;
  final String emptyMessage;
  final Function(BuildContext, LibraryNovel) onMoreTap;

  const LibraryTabContent({
    Key? key,
    required this.future,
    required this.refreshCallback,
    required this.emptyMessage,
    required this.onMoreTap,
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
              );
            },
          );
        },
      ),
    );
  }
}

class NovelListItem extends StatelessWidget {
  final LibraryNovel novel;
  final VoidCallback onMoreTap;

  const NovelListItem({
    Key? key,
    required this.novel,
    required this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}

class LibraryMoreOptionsMenu extends StatelessWidget {
  final LibraryNovel novel;

  const LibraryMoreOptionsMenu({
    Key? key,
    required this.novel,
  }) : super(key: key);

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
          // Header handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Novel Info Header
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
            text: 'Ẩn truyện này đi',
            onTap: () {
              // TODO: Implement hide functionality
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.category_outlined,
            text: 'Xem thể loại truyện',
            onTap: () {
              // TODO: Implement view categories
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.workspace_premium,
            text: 'Nạp vip để nghe không quảng cáo',
            onTap: () {
              Navigator.pop(context); // Đóng bottom sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PremiumScreen1(),
                ),
              );
            },
          ),
          SizedBox(height: 8), // Bottom padding
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