import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySelectionScreen extends StatefulWidget {
  final String userId;

  const CategorySelectionScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  Set<int> selectedGenres = {};
  List<Map<String, dynamic>> genres = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  Future<void> _fetchGenres() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/genres/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8', // Thêm charset
        },
      );

      if (response.statusCode == 200) {
        // Sử dụng utf8.decode cho response.bodyBytes
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          genres = data.map((genre) => {
            'id': genre['id'] as int,
            'name': genre['name'] as String,
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load genres: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load genres. Please try again.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            style: GoogleFonts.roboto(), // Sử dụng Google Fonts
          ),
        ),
      );
    }
  }

  Future<void> _saveSelectedGenres() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.put(
        Uri.parse('http://14.225.207.58:9898/api/v1/select-genres?userId=${widget.userId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8', // Thêm charset
        },
        body: json.encode({
          'selectedGenreIds': selectedGenres.toList()
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã lưu thể loại thành công!',
              style: GoogleFonts.roboto(), // Sử dụng Google Fonts
            ),
          ),
        );
      } else {
        throw Exception('Failed to save genres');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi khi lưu thể loại: $e',
            style: GoogleFonts.roboto(), // Sử dụng Google Fonts
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Chọn Thể Loại',
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Chọn tối đa 3 thể loại bạn yêu thích',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (errorMessage != null)
                    Center(
                      child: Column(
                        children: [
                          Text(
                            errorMessage!,
                            style: GoogleFonts.roboto(
                              color: Colors.red,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _fetchGenres,
                            child: Text(
                              'Thử lại',
                              style: GoogleFonts.roboto(),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 12,
                          children: genres.map((genre) {
                            final isSelected = selectedGenres.contains(genre['id']);
                            return GestureDetector(
                              onTap: () => toggleGenre(genre['id']),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF4CAF50)
                                      : Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF4CAF50)
                                        : Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      genre['name'], // Text thể loại
                                      style: GoogleFonts.roboto( // Sử dụng Google Fonts
                                        fontSize: 15,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      isSelected ? Icons.check_circle : Icons.add_circle,
                                      size: 18,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedGenres.isEmpty ? null : _saveSelectedGenres,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Tiếp tục',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Chọn ít nhất 1 thể loại để tiếp tục',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toggleGenre(int genreId) {
    setState(() {
      if (selectedGenres.contains(genreId)) {
        selectedGenres.remove(genreId);
      } else {
        if (selectedGenres.length < 3) {
          selectedGenres.add(genreId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Chỉ được chọn tối đa 3 thể loại',
                style: GoogleFonts.roboto(),
              ),
            ),
          );
        }
      }
    });
  }
}