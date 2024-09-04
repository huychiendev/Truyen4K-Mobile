import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thư viện'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bottom: TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Đang đọc'),
              Tab(text: 'Đã tải'),
              Tab(text: 'Lịch sử'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReadingList(),
            _buildDownloadedList(),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingList() {
    // Placeholder for reading list
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 50,
            height: 70,
            color: Colors.grey[300],
          ),
          title: Text('Truyện đang đọc ${index + 1}'),
          subtitle: Text('Tác giả ${index + 1}'),
          trailing: Icon(Icons.more_vert),
        );
      },
    );
  }

  Widget _buildDownloadedList() {
    // Placeholder for downloaded list
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 50,
            height: 70,
            color: Colors.grey[300],
          ),
          title: Text('Truyện đã tải ${index + 1}'),
          subtitle: Text('Tác giả ${index + 1}'),
          trailing: Icon(Icons.file_download_done),
        );
      },
    );
  }

  Widget _buildHistoryList() {
    // Placeholder for history list
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 50,
            height: 70,
            color: Colors.grey[300],
          ),
          title: Text('Truyện đã đọc ${index + 1}'),
          subtitle: Text('Đọc lúc: ${DateTime.now().subtract(Duration(days: index)).toString()}'),
          trailing: Icon(Icons.history),
        );
      },
    );
  }
}