import 'dart:convert'; // Import for jsonDecode
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerProvider with ChangeNotifier {
  bool _showMiniPlayer = false;
  String _currentTitle = '';
  String _currentArtist = '';
  String _currentImageUrl = '';
  String _currentSlug = '';
  bool _isPlaying = false;
  String _audioUrl = '';
  double _totalDuration = 0.0;

  // Getters
  bool get showMiniPlayer => _showMiniPlayer;

  String get currentTitle => _currentTitle;

  String get currentArtist => _currentArtist;

  String get currentImageUrl => _currentImageUrl;

  String get currentSlug => _currentSlug;

  bool get isPlaying => _isPlaying;

  String get audioUrl => _audioUrl;

  double get totalDuration => _totalDuration;

  // Function to update player state
  void updatePlayerState({
    bool? showMiniPlayer,
    String? currentTitle,
    String? currentArtist,
    String? currentImageUrl,
    String? currentSlug,
    bool? isPlaying,
    String? audioUrl,
    double? totalDuration,
  }) {
    _showMiniPlayer = showMiniPlayer ?? _showMiniPlayer;
    _currentTitle = currentTitle ?? _currentTitle;
    _currentArtist = currentArtist ?? _currentArtist;
    _currentImageUrl = currentImageUrl ?? _currentImageUrl;
    _currentSlug = currentSlug ?? _currentSlug;
    _isPlaying = isPlaying ?? _isPlaying;
    _audioUrl = audioUrl ?? _audioUrl;
    _totalDuration = totalDuration ?? _totalDuration;

    notifyListeners();
  }

  // Function to fetch chapter details from the API
  Future<Map<String, dynamic>> fetchChapterDetails(String slug,
      [String chapterNo = 'chap-1']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/chapters/$slug/$chapterNo'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'id': data['id'],
        'chapterNo': data['chapterNo'],
      };
    } else {
      throw Exception('Failed to load chapter');
    }
  }

// Function to fetch the audio file details using the chapter ID
  Future<Map<String, dynamic>> fetchAudioFile(int chapterId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/v1/audio-files/$chapterId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'audioUrl': data['audioUrl'],
        'duration': data['duration'], // Duration in seconds
      };
    } else {
      throw Exception('Failed to load audio file');
    }
  }

  // Function to fetch and play audio
  Future<void> playAudio(String slug, [String chapterNo = 'chap-1']) async {
    try {
      // Fetch chapter details
      final chapterDetails = await fetchChapterDetails(slug, chapterNo);
      final chapterId = chapterDetails['id'];

      // Fetch audio file using chapterId
      final audioData = await fetchAudioFile(chapterId);
      final audioUrl = audioData['audioUrl'];
      final duration = audioData['duration']; // in seconds

      // Update player state
      updatePlayerState(
        audioUrl: audioUrl,
        totalDuration: duration.toDouble(),
        isPlaying: true,
      );

      // Play audio logic can be implemented here, for example using an audio player package
    } catch (e) {
      print('Error fetching audio: $e');
    }
  }
}