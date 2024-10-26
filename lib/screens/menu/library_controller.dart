import 'package:flutter/foundation.dart';
import '../../models/library_novel.dart';
import '../../services/novel_service.dart';

class LibraryController with ChangeNotifier {
  Future<List<LibraryNovel>>? savedNovelsFuture;
  Future<List<LibraryNovel>>? downloadedNovelsFuture;
  Future<List<LibraryNovel>>? historyNovelsFuture;
  Future<List<LibraryNovel>>? readingProgressNovelsFuture;
  Future<List<LibraryNovel>>? completedNovelsFuture;

  // Cache data
  List<LibraryNovel>? _cachedSavedNovels;
  List<LibraryNovel>? _cachedReadingNovels;
  List<LibraryNovel>? _cachedCompletedNovels;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void initializeData() {
    refreshSavedNovels();
    refreshDownloadedNovels();
    refreshHistoryNovels();
    refreshReadingProgressNovels();
    refreshCompletedNovels();
  }

  Future<void> refreshSavedNovels() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      savedNovelsFuture = LibraryNovel.fetchSavedNovels();
      _cachedSavedNovels = await savedNovelsFuture;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error refreshing saved novels: $e';
      print(_error);
      notifyListeners();
      throw e;
    }
  }

  void refreshDownloadedNovels() {
    try {
      _isLoading = true;
      notifyListeners();

      downloadedNovelsFuture = Future.value([]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error refreshing downloaded novels: $e';
      notifyListeners();
    }
  }

  void refreshHistoryNovels() {
    try {
      _isLoading = true;
      notifyListeners();

      historyNovelsFuture = Future.value([]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error refreshing history: $e';
      notifyListeners();
    }
  }

  Future<void> refreshReadingProgressNovels() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      readingProgressNovelsFuture = NovelService.fetchReadingProgress();
      _cachedReadingNovels = await readingProgressNovelsFuture;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error refreshing reading progress: $e';
      notifyListeners();
      throw e;
    }
  }

  Future<void> refreshCompletedNovels() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      completedNovelsFuture = NovelService.fetchCompletedNovels();
      _cachedCompletedNovels = await completedNovelsFuture;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error refreshing completed novels: $e';
      notifyListeners();
      throw e;
    }
  }

  // Get cached data methods
  List<LibraryNovel> getSavedNovels() {
    return _cachedSavedNovels ?? [];
  }

  List<LibraryNovel> getReadingNovels() {
    return _cachedReadingNovels ?? [];
  }

  List<LibraryNovel> getCompletedNovels() {
    return _cachedCompletedNovels ?? [];
  }

  // Clear cache method
  void clearCache() {
    _cachedSavedNovels = null;
    _cachedReadingNovels = null;
    _cachedCompletedNovels = null;
    notifyListeners();
  }

  // Error handling method
  void handleError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }

  // Loading state methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Cleanup method
  void dispose() {
    clearCache();
    super.dispose();
  }
}