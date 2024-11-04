import 'package:flutter/material.dart';
import 'package:apptruyenonline/models/library_novel.dart';
import '../menu/genre_novels_screen.dart';
import '../self_screen/register_screen/prime_screen.dart';
import 'library_controller.dart';
import '../item_truyen/view_screen/novel_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  final LibraryController _controller = LibraryController();
  late TabController _tabController;
  bool _isRefreshing = false;

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
            _refreshSavedNovels();
            break;
          case 1:
            _refreshReadingProgress();
            break;
          case 2:
            _refreshCompletedNovels();
            break;
        }
      });
    }
  }

  Future<void> _refreshSavedNovels() async {
    if (!_isRefreshing) {
      setState(() => _isRefreshing = true);
      try {
        await _controller.refreshSavedNovels();
      } finally {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _refreshReadingProgress() async {
    if (!_isRefreshing) {
      setState(() => _isRefreshing = true);
      try {
        await _controller.refreshReadingProgress();
      } finally {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _refreshCompletedNovels() async {
    if (!_isRefreshing) {
      setState(() => _isRefreshing = true);
      try {
        await _controller.refreshCompletedNovels();
      } finally {
        setState(() => _isRefreshing = false);
      }
    }
  }

  void _showMoreOptions(BuildContext context, LibraryNovel novel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNovelInfo(novel),
            Divider(color: Colors.grey[800]),
            _buildMenuOptions(context, novel),
          ],
        ),
      ),
    );
  }

  Widget _buildNovelInfo(LibraryNovel novel) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            image: NetworkImage(novel.thumbnailImageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        novel.title,
        style: TextStyle(color: Colors.white),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        novel.authorName,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context, LibraryNovel novel) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.delete_outline, color: Colors.red),
          title: Text('Xóa khỏi thư viện', style: TextStyle(color: Colors.red)),
          onTap: () async {
            Navigator.pop(context);
            await _controller.deleteNovel(novel.slug);
            _refreshSavedNovels();
          },
        ),
        ListTile(
          leading: Icon(Icons.category_outlined, color: Colors.white),
          title: Text('Xem thể loại', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GenreNovelsScreen(genre: novel.primaryGenre),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.workspace_premium, color: Colors.white),
          title: Text('Nâng cấp VIP', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PremiumScreen1()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLibraryListItem(LibraryNovel novel) {
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
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        novel.subtitle,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert, color: Colors.white),
        onPressed: () => _showMoreOptions(context, novel),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NovelDetailScreen(slug: novel.slug),
        ),
      ),
    );
  }

  Widget _buildLibraryTab({
    required Future<List<LibraryNovel>>? future,
    required VoidCallback refreshCallback,
    required String emptyMessage
  }) {
    return RefreshIndicator(
      onRefresh: () async => refreshCallback(),
      child: FutureBuilder<List<LibraryNovel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !_isRefreshing) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Có lỗi xảy ra: ${snapshot.error}',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: refreshCallback,
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                emptyMessage,
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final novel = snapshot.data![index];
              return _buildLibraryListItem(novel);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          indicatorColor: Colors.green,
          tabs: [
            Tab(text: 'Truyện đã lưu'),
            Tab(text: 'Đang đọc'),
            Tab(text: 'Đã đọc xong'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLibraryTab(
              future: _controller.savedNovelsFuture,
              refreshCallback: _refreshSavedNovels,
              emptyMessage: 'Không có truyện đã lưu'
          ),
          _buildLibraryTab(
              future: _controller.readingProgressFuture,
              refreshCallback: _refreshReadingProgress,
              emptyMessage: 'Không có truyện đang đọc'
          ),
          _buildLibraryTab(
              future: _controller.completedNovelsFuture,
              refreshCallback: _refreshCompletedNovels,
              emptyMessage: 'Không có truyện đã đọc xong'
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}