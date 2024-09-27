import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptruyenonline/screens/menu/audio_player_provider.dart';
import 'package:apptruyenonline/screens/item_truyen/view_screen/mobile_audio_player.dart';
import '../../models/novel_model.dart';
import 'package:apptruyenonline/screens/item_truyen/view_screen/miniplayer.dart';

class ExploreController {
  void startPlayingNovel(Novel novel, BuildContext context) {
    context.read<AudioPlayerProvider>().updatePlayerState(
      showMiniPlayer: true,
      currentTitle: novel.title,
      currentArtist: 'Chương 1',
      currentImageUrl: novel.thumbnailImageUrl,
      currentSlug: novel.slug,
      isPlaying: true,
    );
  }

  Widget buildMiniPlayer(BuildContext context, AudioPlayerProvider audioPlayerProvider) {
    return Dismissible(
      key: Key('mini-player'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        audioPlayerProvider.updatePlayerState(showMiniPlayer: false);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(Icons.close, color: Colors.white),
      ),
      child: MiniPlayer(
        slug: audioPlayerProvider.currentSlug,
        chapterNo: 1,
        title: audioPlayerProvider.currentTitle,
        artist: audioPlayerProvider.currentArtist,
        imageUrl: audioPlayerProvider.currentImageUrl,
        isPlaying: audioPlayerProvider.isPlaying,
        onTap: () => _onMiniPlayerTap(context, audioPlayerProvider),
        onPlayPause: () {
          audioPlayerProvider.updatePlayerState(
            isPlaying: !audioPlayerProvider.isPlaying,
          );
        },
        onNext: () {
          // Handle next track
        },
        onDismiss: () {
          audioPlayerProvider.updatePlayerState(showMiniPlayer: false);
        },
      ),
    );
  }

  void _onMiniPlayerTap(BuildContext context, AudioPlayerProvider audioPlayerProvider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileAudioPlayer(
          slug: audioPlayerProvider.currentSlug,
          chapterNo: 1,
          novelName: audioPlayerProvider.currentTitle,
          thumbnailImageUrl: audioPlayerProvider.currentImageUrl,
        ),
      ),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        audioPlayerProvider.updatePlayerState(
          showMiniPlayer: result['showMiniPlayer'] ?? false,
          currentTitle: result['currentNovelName'] ?? audioPlayerProvider.currentTitle,
          currentArtist: 'Chương ${result['currentChapter'] ?? '1'}',
          isPlaying: result['isPlaying'] ?? audioPlayerProvider.isPlaying,
        );
      }
    });
  }
}