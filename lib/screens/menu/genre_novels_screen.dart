import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/novel_model.dart';
import '../item_truyen/view_screen/novel_detail_screen.dart';

class GenreNovelsScreen extends StatefulWidget {
  final String genre;

  const GenreNovelsScreen({Key? key, required this.genre}) : super(key: key);

  @override
  _GenreNovelsScreenState createState() => _GenreNovelsScreenState();
}

class _GenreNovelsScreenState extends State<GenreNovelsScreen> {
  late Future<List<Novel>> _novelsFuture;

  @override
  void initState() {
    super.initState();
    _novelsFuture = _fetchNovelsByGenre(widget.genre);
  }

  Future<List<Novel>> _fetchNovelsByGenre(String genre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/v1/novels/genre/$genre'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes))['content'];
      return data.map((json) => Novel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load novels');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Novels in ${widget.genre}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to the desired color
        ),
      ),
      backgroundColor: Colors.black87,
      body: FutureBuilder<List<Novel>>(
        future: _novelsFuture,
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
                  leading: Image.network(novel.thumbnailImageUrl,
                      width: 50, height: 75, fit: BoxFit.cover),
                  title:
                      Text(novel.title, style: TextStyle(color: Colors.white)),
                  subtitle: Text(novel.authorName,
                      style: TextStyle(color: Colors.grey)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NovelDetailScreen(slug: novel.slug),
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
}
