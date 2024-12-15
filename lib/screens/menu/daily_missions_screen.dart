import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:apptruyenonline/models/ProfileModel.dart';
import 'package:apptruyenonline/models/User.dart';

class DailyMissionsScreen extends StatefulWidget {
  final String username;
  final int level;
  final double progressValue;
  final List<bool> dailyCheckins;
  final UserProfile userProfile;
  final UserImage? userImage;

  const DailyMissionsScreen({
    Key? key,
    required this.username,
    required this.level,
    required this.progressValue,
    required this.dailyCheckins,
    required this.userProfile,
    this.userImage,
  }) : super(key: key);

  @override
  _DailyMissionsScreenState createState() => _DailyMissionsScreenState();
}

class _DailyMissionsScreenState extends State<DailyMissionsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ImageProvider _getProfileImage() {
    if (widget.userImage?.data != null) {
      try {
        return MemoryImage(base64Decode(widget.userImage!.data));
      } catch (e) {
        print('Error decoding image data: $e');
        return AssetImage('assets/avt.png');
      }
    }
    return AssetImage('assets/avt.png');
  }


  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: _buildGradientAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: AnimationLimiter(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: Duration(milliseconds: 600),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  _buildUserHeader(),
                  _buildDailyCheckin(),
                  _buildMissionsList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildGradientAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A2A4A), Color(0xFF1A1A2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Nhiệm vụ hàng ngày',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Colors.white, Colors.blue[300]!],
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16213E), Color(0xFF1A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'avatar',
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ),
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundImage: _getProfileImage(),
                backgroundColor: Colors.grey[300],
                onBackgroundImageError: (exception, stackTrace) {
                  print('Error loading avatar image: $exception');
                },
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userProfile.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.userProfile.email,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[900]!.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Lv: ${widget.level}',
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildProgressBar(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Stack(
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FractionallySizedBox(
              widthFactor: widget.progressValue,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue[400]!,
                      Colors.purple[400]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue[400]!.withOpacity(0.5),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDailyCheckin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Điểm danh hàng ngày',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              6,
                  (index) => _buildAnimatedDayItem(index + 1, widget.dailyCheckins[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDayItem(int day, bool isChecked) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: isChecked ? math.sin(_controller.value * 2 * math.pi) * 0.05 : 0,
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isChecked
                        ? [Colors.amber, Colors.orange]
                        : [Colors.grey[800]!, Colors.grey[900]!],
                  ),
                  boxShadow: isChecked
                      ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                      : [],
                ),
                child: Icon(
                  Icons.star,
                  color: isChecked ? Colors.white : Colors.grey[600],
                  size: 30,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Day $day',
                style: TextStyle(
                  color: isChecked ? Colors.amber : Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMissionsList() {
    final missions = [
      {
        'icon': Icons.thumb_up,
        'title': 'Like truyện 1 lần',
        'reward': 10,
        'progress': 0.3,
      },
      {
        'icon': Icons.monetization_on,
        'title': 'Nạp tiền 1 lần',
        'reward': 50,
        'progress': 0.0,
      },
      {
        'icon': Icons.check_circle,
        'title': 'Điểm danh hàng ngày',
        'reward': 20,
        'progress': 1.0,
      },
      {
        'icon': Icons.book,
        'title': 'Đọc truyện 30p',
        'reward': 30,
        'progress': 0.7,
      },
    ];

    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Nhiệm vụ hàng ngày',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...missions.asMap().entries.map((entry) {
            return AnimationConfiguration.staggeredList(
              position: entry.key,
              duration: Duration(milliseconds: 500),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildMissionItem(
                    entry.value['icon'] as IconData,
                    entry.value['title'] as String,
                    entry.value['reward'] as int,
                    entry.value['progress'] as double,
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMissionItem(IconData icon, String title, int reward, double progress) {
    final isCompleted = progress >= 1.0;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16213E), Color(0xFF1A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
          children: [
      Row(
      children: [
      Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[900]!.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.blue[300], size: 24),
    ),
    SizedBox(width: 16),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    title,
    style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    ),
    ),
    SizedBox(height: 4),
    Row(
    children: [
    Icon(
    Icons.star,
    color: Colors.amber,
    size: 16,
    ),
    SizedBox(width: 4),
    Text(
    '+$reward',
    style: TextStyle(
    color: Colors.amber,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    AnimatedSwitcher(
    duration: Duration(milliseconds: 300),
    child: isCompleted
    ? TextButton(
    onPressed: () {},
    style: TextButton.styleFrom(
    backgroundColor: Colors.green.withOpacity(0.2),
    padding: EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    child: Text(
    'Nhận',
    style: TextStyle(
    color: Colors.green[300],
    fontWeight: FontWeight.bold,
    ),
    ),
    )
        : Container(
    padding: EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
    ),
    decoration: BoxDecoration(
    color: Colors.blue[900]!.withOpacity(0.3),
    borderRadius: BorderRadius.circular(12),
    ),
    child: Text('${(progress * 100).toInt()}%',
      style: TextStyle(
        color: Colors.blue[300],
        fontWeight: FontWeight.bold,
      ),
    ),
    ),
    ),
      ],
      ),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: progress),
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                builder: (context, double value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? Colors.green[400]! : Colors.blue[400]!,
                    ),
                    minHeight: 6,
                  );
                },
              ),
            ),
          ],
      ),
    );
  }

  // Thêm hiệu ứng confetti khi hoàn thành nhiệm vụ
  void _showCompletionConfetti() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Lottie.network(
                  'https://assets1.lottiefiles.com/packages/lf20_wcnjmdp1.json',
                  repeat: false,
                  onLoaded: (composition) {
                    Future.delayed(composition.duration, () {
                      Navigator.of(context).pop();
                    });
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chúc mừng!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Bạn đã hoàn thành nhiệm vụ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Paint cho hiệu ứng sóng
class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WavePainter(this.animation, this.color) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final y = size.height * (0.8 + 0.2 * math.sin(animation.value * math.pi * 2));

    path.moveTo(0, y);
    for (var i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        y + 10 * math.sin((animation.value * 360 + i) * math.pi / 180),
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}