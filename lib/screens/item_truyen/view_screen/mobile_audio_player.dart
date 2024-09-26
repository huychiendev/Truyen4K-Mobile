import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/widget_Audio/album_art.dart';
import '../../../widgets/widget_Audio/controls.dart';
import '../../../widgets/widget_Audio/footer.dart';
import '../../../widgets/widget_Audio/progress_bar.dart';
import '../../../widgets/widget_Audio/top_bar.dart';
import '../../../widgets/widget_Audio/track_info.dart';

class MobileAudioPlayer extends StatefulWidget {
  final String slug;
  final int chapterNo;
  final String novelName;
  final String thumbnailImageUrl;

  const MobileAudioPlayer({
    Key? key,
    required this.slug,
    required this.chapterNo,
    required this.novelName,
    required this.thumbnailImageUrl,
  }) : super(key: key);

  @override
  _MobileAudioPlayerState createState() => _MobileAudioPlayerState();
}

class _MobileAudioPlayerState extends State<MobileAudioPlayer>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  double progress = 0.0;
  late AnimationController _animationController;
  Timer? _timer;
  double playbackSpeed = 1.0;
  double totalDuration = 0.0; // Total duration in seconds
  bool isLiked = false;
  bool isSaved = false;
  String? audioUrl;
  int chapterId = 0;
  late AudioPlayer _audioPlayer; // Khai báo AudioPlayer
  bool isLoading = true;
  Timer? _progressUpdateTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        totalDuration = d.inSeconds.toDouble();
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        progress = p.inSeconds.toDouble() / totalDuration;
      });
    });

    _fetchAudioDetails();
  }



  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _fetchAudioDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final chapterDetails = await fetchChapterDetails(
          widget.slug, 'chap-${widget.chapterNo}', token);
      final audioDetails =
      await fetchAudioFileDetails(chapterDetails['id'], token);

      if (audioDetails['duration'] == 0) {
        _showNoAudioDialog();
      } else {
        setState(() {
          audioUrl = audioDetails['audioUrl'];
          totalDuration = audioDetails['duration'].toDouble();
          chapterId = audioDetails['chapterId'].toInt();
        });

        await _audioPlayer.setSourceUrl(audioUrl!);
        // Note: We don't auto-play here
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> fetchChapterDetails(
      String slug, String chapterNo, String? token) async {
    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/chapters/$slug/$chapterNo'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load chapter details');
    }
  }

  Future<Map<String, dynamic>> fetchAudioFileDetails(
      int chapterId, String? token) async {
    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/audio-files/$chapterId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load audio file details');
    }
  }
  void _showNoAudioDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chưa có âm thanh !'),
          content: Text('Thử chuương hoac truyện khác nheng !'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the player screen
              },
            ),
          ],
        );
      },
    );
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _animationController.forward();
        _audioPlayer.resume();
      } else {
        _animationController.reverse();
        _audioPlayer.pause();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer =
        Timer.periodic(Duration(milliseconds: (50 ~/ playbackSpeed)), (timer) {
      setState(() {
        if (progress < 1.0) {
          progress += 0.0001 * playbackSpeed;
        } else {
          progress = 0.0;
          _togglePlayPause();
        }
      });
    });
  }

  void _changePlaybackSpeed() {
    setState(() {
      if (playbackSpeed == 1.0) {
        playbackSpeed = 1.5;
      } else if (playbackSpeed == 1.5) {
        playbackSpeed = 2.0;
      } else {
        playbackSpeed = 1.0;
      }
      _audioPlayer.setPlaybackRate(playbackSpeed); // Change playback speed
      if (isPlaying) {
        _startTimer();
      }
    });
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });
  }

  String _formatDuration(double seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds.toInt() % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        body: Hero(
          tag: 'player-hero',
          child: Material(
            color: Colors.black,
            child: Stack(
              children: [
                _buildFullPlayer(),
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _handleWillPop() async {
    _minimizePlayer();
    return false;
  }

  void _minimizePlayer() {
    Navigator.pop(context, {
      'showMiniPlayer': true,
      'currentChapter': widget.chapterNo.toString(),
      'currentNovelName': widget.novelName,
      'isPlaying': isPlaying,
      'progress': progress,
    });
  }

  Widget _buildFullPlayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TopBar(
              onMinimizePlayer: _minimizePlayer,
              isLiked: isLiked,
              isSaved: isSaved,
              onToggleLike: _toggleLike,
              onToggleSave: _toggleSave,
            ),
            const SizedBox(height: 24),
            Flexible(
                child: AlbumArt(thumbnailImageUrl: widget.thumbnailImageUrl)),
            const SizedBox(height: 24),
            TrackInfo(novelName: widget.novelName, chapterNo: widget.chapterNo),
            const SizedBox(height: 24),
            ProgressBar(
              progress: progress,
              totalDuration: totalDuration,
              onChanged: (value) {
                setState(() {
                  progress = value;
                  _audioPlayer.seek(Duration(
                      seconds: (totalDuration * progress)
                          .toInt())); // Thay đổi vị trí phát nhạc
                });
              },
            ),
            const SizedBox(height: 24),
            Controls(
              isPlaying: isPlaying,
              onTogglePlayPause: _togglePlayPause,
            ),
            const SizedBox(height: 24),
            Footer(
              playbackSpeed: playbackSpeed,
              onChangePlaybackSpeed: _changePlaybackSpeed,
            ),
          ],
        ),
      ),
    );
  }
}
