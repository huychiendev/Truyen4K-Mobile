import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../item_truyen/view_screen/novel_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Future<List<dynamic>>? _savedNovelsFuture;
  Future<List<dynamic>>? _downloadedNovelsFuture;
  Future<List<dynamic>>? _historyNovelsFuture;

  _LibraryScreenState() {
    _savedNovelsFuture = fetchSavedNovels();
    _downloadedNovelsFuture = fetchNovels();
    _historyNovelsFuture = fetchNovels();
  }

  Future<List<dynamic>> fetchNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(
          'http://14.225.207.58:9898/api/novels/new-released?page=0&size=20'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> novels = data['content'];
      novels.shuffle(Random());
      return novels;
    } else {
      throw Exception('Failed to load new released novels');
    }
  }

  Future<List<dynamic>> fetchSavedNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? username = prefs.getString('username');
    String key = 'saved_items';

    if (username == null) {
      throw Exception('Username not found');
    }

    List<String> savedItems = prefs.getStringList(key) ?? [];
    List<dynamic> novels = [];

    for (String item in savedItems) {
      if (item.startsWith('$username,')) {
        String slug = item.split(',')[1];
        final response = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/novels/$slug'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          novels.add(jsonDecode(utf8.decode(response.bodyBytes)));
        } else {
          throw Exception('Failed to load novel details');
        }
      }
    }

    return novels;
  }

  Future<void> _refreshSavedNovels() async {
    setState(() {
      _savedNovelsFuture = fetchSavedNovels();
    });
  }

  Future<void> _refreshDownloadedNovels() async {
    setState(() {
      _downloadedNovelsFuture = fetchNovels();
    });
  }

  Future<void> _refreshHistoryNovels() async {
    setState(() {
      _historyNovelsFuture = fetchNovels();
    });
  }

  Widget _buildSaveList() {
    return RefreshIndicator(
      onRefresh: _refreshSavedNovels,
      child: FutureBuilder<List<dynamic>>(
        future: _savedNovelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No saved novels found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final novel = snapshot.data![index];
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 70,
                    color: Colors.grey[300],
                    child: Image.network(novel['thumbnailImageUrl'],
                        fit: BoxFit.cover),
                  ),
                  title: Text(
                    novel['title'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    novel['authorName'],
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(Icons.more_vert),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NovelDetailScreen(slug: novel['slug']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDownloadedList() {
    return RefreshIndicator(
      onRefresh: _refreshDownloadedNovels,
      child: FutureBuilder<List<dynamic>>(
        future: _downloadedNovelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No novels found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final novel = snapshot.data![index];
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 70,
                    color: Colors.grey[300],
                    child: Image.network(novel['thumbnailImageUrl'],
                        fit: BoxFit.cover),
                  ),
                  title: Text(
                    novel['title'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    novel['authorName'],
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(Icons.file_download_done),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NovelDetailScreen(slug: novel['slug']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildHistoryList() {
    return RefreshIndicator(
      onRefresh: _refreshHistoryNovels,
      child: FutureBuilder<List<dynamic>>(
        future: _historyNovelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No novels found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final novel = snapshot.data![index];
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 70,
                    color: Colors.grey[300],
                    child: Image.network(novel['thumbnailImageUrl'],
                        fit: BoxFit.cover),
                  ),
                  title: Text(
                    novel['title'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Đọc lúc: ${DateTime.now().subtract(Duration(days: index)).toString()}',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(Icons.history),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NovelDetailScreen(slug: novel['slug']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
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
            _buildSaveList(),
            _buildDownloadedList(),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }
}


