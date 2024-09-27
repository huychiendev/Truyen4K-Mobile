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
            _controller.refreshReadingProgressNovels(); // New method
            break;
          case 2:
            _controller.refreshHistoryNovels();
            break;
        }
      });
    }
  }


  Future<List<LibraryNovel>> _handleNullableFuture(
      Future<List<LibraryNovel>>? future) {
    return future ?? Future.value([]);
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
            LibraryTab(
              future: _handleNullableFuture(_controller.savedNovelsFuture),
              refreshCallback: _controller.refreshSavedNovels,
              emptyMessage: 'Không tìm thấy truyện đã lưu.',
            ),
            LibraryTab(
              future: _handleNullableFuture(_controller.readingProgressNovelsFuture),
              refreshCallback: _controller.refreshReadingProgressNovels,
              emptyMessage: 'Không tìm thấy truyện đang đọc.',
            ),
            LibraryTab(
              future: _handleNullableFuture(_controller.completedNovelsFuture), // New future
              refreshCallback: _controller.refreshCompletedNovels, // New callback
              emptyMessage: 'Không tìm thấy truyện đã đọc xong.',
            ),
          ],
        ),
      ),
    );
  }
}
