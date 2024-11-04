// screens/menu/library_controller.dart

import 'package:flutter/foundation.dart';
import '../../../models/library_novel.dart';
import '../../../services/library_service.dart';

class LibraryController with ChangeNotifier {
  Future<List<LibraryNovel>>? savedNovelsFuture;
  Future<List<LibraryNovel>>? readingProgressFuture;
  Future<List<LibraryNovel>>? completedNovelsFuture;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void initializeData() {
    refreshSavedNovels();
    refreshReadingProgress();
    refreshCompletedNovels();
  }

  Future<void> refreshSavedNovels() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      savedNovelsFuture = NovelService.fetchSavedNovels();
      await savedNovelsFuture;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error refreshing saved novels: $e';
      notifyListeners();
      throw e;
    }
  }

  Future<void> refreshReadingProgress() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      readingProgressFuture = NovelService.fetchReadingProgress();
      await readingProgressFuture;

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
      await completedNovelsFuture;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error refreshing completed novels: $e';
      notifyListeners();
      throw e;
    }
  }

  // Delete novel from library
  Future<void> deleteNovel(String slug) async {
    try {
      await NovelService.deleteNovel(slug);
      refreshSavedNovels();
    } catch (e) {
      _error = 'Error deleting novel: $e';
      notifyListeners();
      throw e;
    }
  }

  // Save reading progress
  Future<void> saveProgress(String slug, int chapterNo) async {
    try {
      await NovelService.saveProgress(slug, chapterNo);
      refreshReadingProgress();
    } catch (e) {
      _error = 'Error saving progress: $e';
      notifyListeners();
      throw e;
    }
  }

  void handleError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}