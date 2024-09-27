import 'package:flutter/material.dart';
import '../../widgets/library_widgets/library_tab.dart';
import 'library_controller.dart';
import '../../models/library_novel.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final LibraryController _controller = LibraryController();

  @override
  void initState() {
    super.initState();
    _controller.initializeData();
  }

  Future<List<LibraryNovel>> _handleNullableFuture(Future<List<LibraryNovel>>? future) {
    return future ?? Future.value([]);
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
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Truyện đã lưu'),
              Tab(text: 'Đang nghe'),
              Tab(text: 'Đã Đọc Xong'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LibraryTab(
              future: _handleNullableFuture(_controller.savedNovelsFuture),
              refreshCallback: _controller.refreshSavedNovels,
              emptyMessage: 'Không tìm thấy truyện đã lưu.',
            ),
            LibraryTab(
              future: _handleNullableFuture(_controller.downloadedNovelsFuture),
              refreshCallback: _controller.refreshDownloadedNovels,
              emptyMessage: 'Không tìm thấy truyện.',
            ),
            LibraryTab(
              future: _handleNullableFuture(_controller.historyNovelsFuture),
              refreshCallback: _controller.refreshHistoryNovels,
              emptyMessage: 'Không tìm thấy truyện.',
            ),
          ],
        ),
      ),
    );
  }
}