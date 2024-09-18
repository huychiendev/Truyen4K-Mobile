import 'package:flutter/material.dart';

class MobileAudioPlayer extends StatefulWidget {
  final String slug;
  final int chapterNo;
  final String novelName;
  final String thumbnailImageUrl; // Thêm dòng này

  const MobileAudioPlayer({
    Key? key,
    required this.slug,
    required this.chapterNo,
    required this.novelName,
    required this.thumbnailImageUrl, // Thêm dòng này
  }) : super(key: key);

  @override
  _MobileAudioPlayerState createState() => _MobileAudioPlayerState();
}

class _MobileAudioPlayerState extends State<MobileAudioPlayer> {
  bool isPlaying = false;
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        body: _buildFullPlayer(),
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
    return GestureDetector(
      onTap: _minimizePlayer,
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTopBar(),
                SizedBox(height: 24),
                _buildAlbumArt(),
                SizedBox(height: 24),
                _buildTrackInfo(),
                SizedBox(height: 24),
                _buildProgressBar(),
                SizedBox(height: 24),
                _buildControls(),
                SizedBox(height: 24),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Xây dựng thanh trên cùng
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24),
          onPressed: _minimizePlayer,
        ),
        Icon(Icons.more_vert, color: Colors.white, size: 24),
      ],
    );
  }

  // Xây dựng ảnh bìa album
  Widget _buildAlbumArt() {
    return Expanded(
      child: Center(
        child: Container(
          width: 256,
          height: 256,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image(
            image: NetworkImage(widget.thumbnailImageUrl),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image_not_supported, size: 64, color: Colors.white);
            },
          ),
        ),
      ),
    );
  }

  // Xây dựng thông tin tiểu thuyết và chương
  Widget _buildTrackInfo() {
    return Column(
      children: [
        Text(
          widget.novelName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Chương ${widget.chapterNo}',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // Xây dựng thanh tiến trình
  Widget _buildProgressBar() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.grey[700],
            thumbColor: Colors.white,
            overlayColor: Colors.white.withAlpha(32),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
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
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0:00', style: TextStyle(color: Colors.white, fontSize: 12)),
            Text('-2:08', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  // Xây dựng các nút điều khiển
  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.skip_previous, color: Colors.white, size: 36),
          onPressed: () {
            // Xử lý chuyển chương trước
          },
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isPlaying = !isPlaying;
            });
          },
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
          icon: Icon(Icons.skip_next, color: Colors.white, size: 36),
          onPressed: () {
            // Xử lý chuyển chương tiếp theo
          },
        ),
      ],
    );
  }
}

  // Xây dựng footer
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.nightlight_round, color: Colors.white, size: 24),
        Text('1.0x', style: TextStyle(color: Colors.white)),
      ],
    );
  }

  // Xây dựng mini player
  Widget _buildMiniPlayer() {
    // Có thể bỏ qua phần này vì mini player sẽ được sử dụng trong NovelDetailScreen
    return Container();
  }
