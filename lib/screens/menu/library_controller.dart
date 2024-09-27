import 'package:apptruyenonline/services/novel_service.dart';

import '../../models/library_novel.dart';

class LibraryController {
  Future<List<LibraryNovel>>? savedNovelsFuture;
  Future<List<LibraryNovel>>? downloadedNovelsFuture;
  Future<List<LibraryNovel>>? historyNovelsFuture;
  Future<List<LibraryNovel>>? readingProgressNovelsFuture;
  Future<List<LibraryNovel>>? completedNovelsFuture; // Add this line

  void initializeData() {
    refreshSavedNovels();
    refreshDownloadedNovels();
    refreshHistoryNovels();
    refreshReadingProgressNovels();
    refreshCompletedNovels(); // Add this line
  }

  void refreshSavedNovels() {
    savedNovelsFuture = LibraryNovel.fetchSavedNovels();
  }

  void refreshDownloadedNovels() {
    downloadedNovelsFuture = Future.value([]);
  }

  void refreshHistoryNovels() {
    historyNovelsFuture = Future.value([]);
  }

  void refreshReadingProgressNovels() {
    readingProgressNovelsFuture = NovelService.fetchReadingProgress();
  }

  void refreshCompletedNovels() {
    completedNovelsFuture = NovelService.fetchCompletedNovels();
  }
}
