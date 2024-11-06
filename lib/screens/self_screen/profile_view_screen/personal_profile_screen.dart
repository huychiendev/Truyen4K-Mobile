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
  bool _isLoading = true;
  String? _error;

  final Map<String, int> cultivationLevels = {
    'Đấu Khí': 0,
    'Đấu Giả': 51,
    'Đấu Sư': 151,
    'Đại Đấu Sư': 301,
    'Đấu Linh': 501,
    'Đấu Vương': 801,
    'Đấu Hoàng': 1201,
    'Đấu Tông': 1801,
    'Đấu Tôn': 2501,
    'Đấu Thánh': 3501,
    'Đấu Đế': 5001,
  };

  @override
  void initState() {
    super.initState();
    _checkToken();
    _fetchUserDetails();
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      int? userId = prefs.getInt('user_id');

      print('Token: $token');
      print('UserId: $userId');

      if (token != null && userId != null) {
        final response = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/v1/images/?userId=$userId'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final List<dynamic> imageData = json.decode(utf8.decode(response.bodyBytes));
          if (imageData.isNotEmpty) {
            setState(() {
              _userImage = UserImage.fromJson(imageData[0]);
            });
          } else {
            print('No image data found');
          }
        } else {
          throw Exception('Failed to load user image: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('auth_token');
        int? userId = prefs.getInt('user_id');

        if (token == null || userId == null) {
          throw Exception('Token or userId not found');
        }

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://14.225.207.58:9898/api/v1/images/upload?userId=$userId'),
        );

        // Thêm headers
        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Content-Type'] = 'multipart/form-data';

        request.files.add(await http.MultipartFile.fromPath('file', image.path));

        // Đợi response
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          setState(() {
            _selectedImage = File(image.path);
          });

          // Đợi fetch xong mới update UI
          await _fetchUserDetails();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ảnh đã được tải lên thành công')),
          );
        } else {
          throw Exception('Upload failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }

  String getCultivationLevel(int chaptersRead) {
    String level = 'Đấu Khí';
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
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
          if (_error != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_error!, style: TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: _fetchUserDetails,
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            ),
          if (!_isLoading && _error == null)
            _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
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
    );
  }

  Widget _buildProfileImage() {
    ImageProvider getImageProvider() {
      if (_selectedImage != null) {
        return FileImage(_selectedImage!);
      } else if (_userImage?.data != null) {
        try {
          return MemoryImage(base64Decode(_userImage!.data));
        } catch (e) {
          print('Error decoding image data: $e');
          return AssetImage('assets/avt.png');
        }
      }
      return AssetImage('assets/avt.png');
    }

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
              image: getImageProvider(),
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
    String level = getCultivationLevel(_userImage?.user.chapterReadCount ?? 0);
    return Column(
      children: [
        Image.asset(
          'assets/level/$level.webp',
          width: 90,
          height: 90,
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
            _buildInfoItem('Email', _userImage?.user.email ?? 'N/A'),
            _buildInfoItem('Cấp độ', getCultivationLevel(_userImage?.user.chapterReadCount ?? 0)),
            _buildInfoItem('Vai trò', _userImage?.user.roles.map((role) => role.name).join(', ') ?? 'N/A'),
            _buildInfoItem('Trạng thái', _userImage?.user.status ?? 'N/A'),
            _buildInfoItem('Số chương đã đọc', _userImage?.user.chapterReadCount.toString() ?? '0'),
            _buildInfoItem('Lần cuối sửa ảnh', _userImage != null ? formatDate(_userImage!.createdAt) : 'N/A'),
            _buildInfoItem('Số chương yêu cầu', cultivationLevels[getCultivationLevel(_userImage?.user.chapterReadCount ?? 0)]?.toString() ?? '0'),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label:', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(child: Text(value, style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}