import 'package:flutter/material.dart';
import '../../models/library_novel.dart';
import '../../services/library_service.dart';

class LibraryController {
  final LibraryService _service = LibraryService();

  Future<List<LibraryNovel>>? savedNovelsFuture;
  Future<List<LibraryNovel>>? downloadedNovelsFuture;
  Future<List<LibraryNovel>>? historyNovelsFuture;

  void initializeData() {
    savedNovelsFuture = _service.fetchSavedNovels();
    downloadedNovelsFuture = _service.fetchNovels();
    historyNovelsFuture = _service.fetchNovels();
  }

  Future<void> refreshSavedNovels() async {
    savedNovelsFuture = _service.fetchSavedNovels();
  }

  Future<void> refreshDownloadedNovels() async {
    downloadedNovelsFuture = _service.fetchNovels();
  }

  Future<void> refreshHistoryNovels() async {
    historyNovelsFuture = _service.fetchNovels();
  }
}