import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class MiniPlayer extends StatefulWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onDismiss;
  final bool isPlaying;
  final String slug;
  final int chapterNo;

  const MiniPlayer({
    Key? key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.onTap,
    required this.onPlayPause,
    required this.onNext,
    required this.onDismiss,
    required this.isPlaying,
    required this.slug,
    required this.chapterNo,
  }) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  Future<String> fetchAudioUrl(String slug, int chapterNo) async {
    try {
      final response = await http.get(
        Uri.parse('http://167.71.207.135:3000/audio/${slug}_chapter_$chapterNo.mp3'),
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('audio/mpeg') ?? false) {
          return response.request!.url.toString();
        } else {
          print('Unexpected content type: ${response.headers['content-type']}');
          throw Exception('Failed to load audio');
        }
      } else if (response.statusCode == 404) {
        print('Audio not found: ${response.statusCode}');
        throw Exception('Audio not found');
      } else {
        print('Server error: ${response.statusCode}');
        throw Exception('Failed to load audio');
      }
    } catch (e) {
      print('Error fetching audio URL: $e');
      throw Exception('Failed to load audio');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    _audioPlayer = AudioPlayer();

    // Fetch the audio URL and start playing
    fetchAudioUrl(widget.slug, widget.chapterNo).then((audioUrl) {
      _playAudio(audioUrl);
    }).catchError((error) {
      print('Failed to load audio: $error');
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
  }

  void _stopAudio() async {
    await _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 56),
          child: Opacity(
            opacity: _animation.value,
            child: Dismissible(
              key: Key('mini-player'),
              direction: DismissDirection.down,
              onDismissed: (_) => widget.onDismiss(),
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'album-art',
                        child: Container(
                          width: 56,
                          height: 56,
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[800]),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                widget.artist,
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      PlayPauseButton(
                        isPlaying: _isPlaying,
                        onPressed: () {
                          if (_isPlaying) {
                            _pauseAudio();
                          } else {
                            fetchAudioUrl(widget.slug, widget.chapterNo)
                                .then((audioUrl) {
                              _playAudio(audioUrl);
                            });
                          }
                          widget.onPlayPause();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.white),
                        onPressed: widget.onNext,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PlayPauseButton extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const PlayPauseButton({
    Key? key,
    required this.isPlaying,
    required this.onPressed,
  }) : super(key: key);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: widget.onPressed,
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: AlwaysStoppedAnimation(widget.isPlaying ? 1.0 : 0.0),
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}