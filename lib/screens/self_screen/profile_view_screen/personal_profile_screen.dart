import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/ProfileModel.dart';
import '../../../models/User.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PersonalProfileScreen extends StatefulWidget {
  @override
  _PersonalProfileScreenState createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  UserProfile? _userProfile;
  UserImage? _userImage;
  File? _selectedImage;
  bool _isLoading = true;
  bool _isUploadingImage = false;
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
      String? username = prefs.getString('username');

      if (token == null || username == null) {
        throw Exception('Token or username not found');
      }

      // Fetch profile data
      final profileResponse = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/profile/$username'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (profileResponse.statusCode == 200) {
        final profileData = json.decode(utf8.decode(profileResponse.bodyBytes));
        final userProfile = UserProfile.fromJson(profileData);

        setState(() {
          _userProfile = userProfile;
        });

        // Fetch user image if needed
        if (userProfile.imagePath != null) {
          final imageResponse = await http.get(Uri.parse(userProfile.imagePath!));
          if (imageResponse.statusCode == 200) {
            setState(() {
              _userImage = UserImage(
                id: 0,
                type: 'image/jpeg',
                data: base64Encode(imageResponse.bodyBytes),
                createdAt: DateTime.now().toIso8601String(),
                user: userProfile,
              );
            });
          }
        }
      } else {
        throw Exception('Failed to load profile: ${profileResponse.statusCode}');
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
      // Chọn ảnh từ thư viện hoặc camera
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFF1D1E33),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Chọn ảnh từ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey[800]),
                  ListTile(
                    leading: Icon(Icons.camera_alt, color: Colors.greenAccent),
                    title: Text('Máy ảnh', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library, color: Colors.greenAccent),
                    title: Text('Thư viện', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      );

      if (source == null) return;

      setState(() => _isUploadingImage = true);

      final ImagePicker picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (imageFile == null) {
        setState(() => _isUploadingImage = false);
        return;
      }

      final File file = File(imageFile.path);
      if (!await file.exists()) {
        throw Exception('File không tồn tại');
      }

      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      final String? userId = prefs.getString('user_id');

      if (token == null || userId == null) {
        throw Exception('Vui lòng đăng nhập lại');
      }

      // Hiển thị tiến trình tải lên
      bool isUploading = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Color(0xFF1D1E33),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.greenAccent),
                  SizedBox(height: 16),
                  Text(
                    'Đang tải ảnh lên...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Chuẩn bị request upload
      var uri = Uri.parse('http://14.225.207.58:9898/api/images/upload');
      uri = uri.replace(queryParameters: {'userId': userId});

      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Content-Type'] = 'multipart/form-data'
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: imageFile.name,
        ));

      // Gửi yêu cầu
      final streamedResponse = await request.send().timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Hết thời gian chờ upload');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      // Đóng hộp thoại tiến trình
      if (isUploading) {
        Navigator.of(context).pop();
        isUploading = false;
      }

      if (response.statusCode == 200) {
        // Cập nhật UI sau khi tải lên thành công
        setState(() {
          _selectedImage = file;
        });

        await _fetchUserDetails();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cập nhật ảnh đại diện thành công'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ));
      } else {
        throw Exception('Upload thất bại: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lỗi: ${e.toString()}'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  String getCultivationLevel(int chaptersRead) {
    return _userProfile?.tierName ?? 'Đấu Khí';
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
          onTap: _isUploadingImage ? null : _pickAndUploadImage,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
            child: _isUploadingImage
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
                : Icon(Icons.camera_alt, color: Colors.black, size: 20),
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
            _buildInfoItem('Email', _userProfile?.email ?? 'N/A'),
            _buildInfoItem('Cấp độ', _userProfile?.tierName ?? 'N/A'),
            _buildInfoItem('Trạng thái', _userProfile?.accountStatus ?? 'N/A'),
            _buildInfoItem('Số chương đã đọc', _userProfile?.chapterReadCount.toString() ?? '0'),
            _buildInfoItem('Điểm', _userProfile?.point.toString() ?? '0'),
            if (_userProfile?.selectedGenreIds?.isNotEmpty ?? false)
              _buildInfoItem('Thể loại đã chọn', _userProfile!.selectedGenreIds!.join(', ')),
            if (_userImage != null)
              _buildInfoItem('Lần cuối sửa ảnh', formatDate(_userImage!.createdAt)),
            _buildInfoItem('Số chương yêu cầu',
                cultivationLevels[getCultivationLevel(_userProfile?.chapterReadCount ?? 0)]?.toString() ?? '0'),
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