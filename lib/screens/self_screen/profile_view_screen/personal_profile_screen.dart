import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/User.dart';
import '../../../services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PersonalProfileScreen extends StatefulWidget {
  @override
  _PersonalProfileScreenState createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  UserImage? _userImage;
  File? _selectedImage;

  final Map<String, int> cultivationLevels = {
    'Luyện Khí': 20,
    'Trúc Cơ': 50,
    'Kết Đan': 110,
    'Nguyên Anh': 230,
    'Hóa Thần': 470,
    'Luyện Hư': 950,
    'Đại Thừa': 1910,
  };

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');

    if (token != null && userId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/images/?userId=$userId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> imageData = json.decode(utf8.decode(response.bodyBytes));
          if (imageData.isNotEmpty) {
            UserImage userImage = UserImage.fromJson(imageData[0]);
            setState(() {
              _userImage = userImage;
            });
          }
        } else {
          print('Failed to load image data');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      int? userId = prefs.getInt('user_id');

      if (token != null && userId != null) {
        try {
          await AuthService.uploadUserImage(token, userId, _selectedImage!);
          _fetchUserDetails();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ảnh đã được tải lên thành công')),
          );
        } catch (e) {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không thể tải ảnh lên')),
          );
        }
      }
    }
  }

  String getCultivationLevel(int chaptersRead) {
    String level = 'Luyện Khí';
    for (var entry in cultivationLevels.entries) {
      if (chaptersRead >= entry.value) {
        level = entry.key;
      } else {
        break;
      }
    }
    return level;
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Hồ sơ cá nhân', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF1D1E33),
        elevation: 0,
      ),
      body: _userImage == null
          ? Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileImage(),
              SizedBox(height: 24),
              _buildCultivationIcon(),
              SizedBox(height: 16),
              _buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.greenAccent, width: 2),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: _selectedImage != null
                  ? FileImage(_selectedImage!) as ImageProvider
                  : _userImage!.data != null
                  ? MemoryImage(base64Decode(_userImage!.data))
                  : AssetImage('assets/avt.png') as ImageProvider,
            ),
          ),
        ),
        GestureDetector(
          onTap: _pickAndUploadImage,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.camera_alt, color: Colors.black, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildCultivationIcon() {
    String level = getCultivationLevel(_userImage!.user.chapterReadCount);
    return Column(
      children: [
        Image.asset(
          'assets/level/$level.webp',
          width: 60,
          height: 60,
        ),
        SizedBox(height: 8),
        Text(
          level,
          style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Color(0xFF1D1E33),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem('Email', _userImage!.user.email),
            _buildInfoItem('Cấp độ', getCultivationLevel(_userImage!.user.chapterReadCount)),
            _buildInfoItem('Vai trò', _userImage!.user.roles.map((role) => role.name).join(', ')),
            _buildInfoItem('Trạng thái', _userImage!.user.status),
            _buildInfoItem('Số chương đã đọc', _userImage!.user.chapterReadCount.toString()),
            _buildInfoItem('Lần cuối sửa ảnh', formatDate(_userImage!.createdAt)),
            _buildInfoItem('Số chương yêu cầu', cultivationLevels[getCultivationLevel(_userImage!.user.chapterReadCount)]?.toString() ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}