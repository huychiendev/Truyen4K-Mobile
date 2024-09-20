import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

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

class _MobileAudioPlayerState extends State<MobileAudioPlayer> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  double progress = 0.0;
  late AnimationController _animationController;
  Timer? _timer;
  double playbackSpeed = 1.0;
  final double totalDuration = 128.0; // Total duration in seconds
  bool isLiked = false;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _animationController.forward();
        _startTimer();
      } else {
        _animationController.reverse();
        _timer?.cancel();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: (50 ~/ playbackSpeed)), (timer) {
      setState(() {
        if (progress < 1.0) {
          progress += 0.001 * playbackSpeed;
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
            child: _buildFullPlayer(),
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
            _buildTopBar(),
            const SizedBox(height: 24),
            Flexible(child: _buildAlbumArt()),
            const SizedBox(height: 24),
            _buildTrackInfo(),
            const SizedBox(height: 24),
            _buildProgressBar(),
            const SizedBox(height: 24),
            _buildControls(),
            const SizedBox(height: 24),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24),
          onPressed: _minimizePlayer,
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.white, size: 24),
          onSelected: (String result) {
            if (result == 'like') {
              _toggleLike();
            } else if (result == 'save') {
              _toggleSave();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'like',
              child: Row(
                children: [
                  Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : null),
                  const SizedBox(width: 8),
                  Text(isLiked ? 'Unlike' : 'Like'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'save',
              child: Row(
                children: [
                  Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                  const SizedBox(width: 8),
                  Text(isSaved ? 'Unsave' : 'Save'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlbumArt() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(8),
        ),
        child: CachedNetworkImage(
          imageUrl: widget.thumbnailImageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.image_not_supported, size: 64, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTrackInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.novelName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Chương ${widget.chapterNo}',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.grey[700],
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
            ),
            child: Slider(
              value: progress,
              onChanged: (value) {
                setState(() {
                  progress = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(progress * totalDuration), style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('-${_formatDuration((1 - progress) * totalDuration)}', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
            onPressed: () {
              // Handle previous chapter
            },
          ),
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
            onPressed: () {
              // Handle next chapter
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.nightlight_round, color: Colors.white, size: 24),
          GestureDetector(
            onTap: _changePlaybackSpeed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${playbackSpeed.toStringAsFixed(1)}x',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}