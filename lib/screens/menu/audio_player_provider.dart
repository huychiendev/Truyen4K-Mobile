import 'package:flutter/foundation.dart';

class AudioPlayerProvider with ChangeNotifier {
  bool _showMiniPlayer = false;
  String _currentTitle = '';
  String _currentArtist = '';
  String _currentImageUrl = '';
  String _currentSlug = '';
  bool _isPlaying = false;

  bool get showMiniPlayer => _showMiniPlayer;
  String get currentTitle => _currentTitle;
  String get currentArtist => _currentArtist;
  String get currentImageUrl => _currentImageUrl;
  String get currentSlug => _currentSlug;
  bool get isPlaying => _isPlaying;

  void updatePlayerState({
    bool? showMiniPlayer,
    String? currentTitle,
    String? currentArtist,
    String? currentImageUrl,
    String? currentSlug,
    bool? isPlaying,
  }) {
    _showMiniPlayer = showMiniPlayer ?? _showMiniPlayer;
    _currentTitle = currentTitle ?? _currentTitle;
    _currentArtist = currentArtist ?? _currentArtist;
    _currentImageUrl = currentImageUrl ?? _currentImageUrl;
    _currentSlug = currentSlug ?? _currentSlug;
    _isPlaying = isPlaying ?? _isPlaying;
    notifyListeners();
  }
}