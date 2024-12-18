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

      // 1. Fetch profile data
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

        // 2. Fetch user avatar using correct endpoint
        final avatarResponse = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/v1/images/?userId=${userProfile.id}'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (avatarResponse.statusCode == 200) {
          final List<dynamic> images = json.decode(utf8.decode(avatarResponse.bodyBytes));
          if (images.isNotEmpty) {
            setState(() {
              _userImage = UserImage(
                id: images[0]['id'] ?? 0,
                type: images[0]['type'] ?? 'image/jpeg',
                data: images[0]['data'],
                createdAt: images[0]['createdAt'] ?? DateTime.now().toIso8601String(),
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
      final userId = _userProfile?.id.toString();

      if (token == null || userId == null) {
        throw Exception('Vui lòng đăng nhập lại');
      }

      var uri = Uri.parse('http://14.225.207.58:9898/api/v1/images/upload');
      uri = uri.replace(queryParameters: {'userId': userId});

      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: imageFile.name,
        ));

      final response = await request.send();
      final responseStr = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        await _fetchUserDetails(); // Refresh profile after successful upload
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ảnh đại diện đã được cập nhật'))
        );
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
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
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Thông tin cá nhân'),
              _buildInfoItem('Họ và tên', _userProfile?.fullName ?? 'N/A'),
              _buildInfoItem('Tên đăng nhập', _userProfile?.username ?? 'N/A'),
              _buildInfoItem('Email', _userProfile?.email ?? 'N/A'),
              _buildInfoItem('Trạng thái', _userProfile?.accountStatus ?? 'N/A'),
              _buildInfoItem(
                'Ngày tham gia',
                _userProfile?.createdAt != null
                    ? formatDate(_userProfile!.createdAt!)
                    : 'N/A',
              ),
              _buildInfoItem(
                'Cập nhật lần cuối',
                _userProfile?.updatedAt != null
                    ? formatDate(_userProfile!.updatedAt!)
                    : 'Chưa cập nhật',
              ),
              Divider(color: Colors.grey[800], height: 32),
              _buildSectionHeader('Thống kê đọc truyện'),
              _buildInfoItem('Điểm tích lũy', '${_userProfile?.point ?? 0} điểm'),
              _buildInfoItem(
                  'Số chương đã đọc', '${_userProfile?.chapterReadCount ?? 0} chương'),
              _buildInfoItem('Cấp độ tu luyện', _userProfile?.tierName ?? 'N/A'),
              _buildInfoItem(
                  'Người theo dõi', '${_userProfile?.followerCount ?? 0} người'),
              Divider(color: Colors.grey[800], height: 32),
              _buildSectionHeader('Thông tin ví và gói Premium'),
              _buildInfoItem('Số xu hiện tại', '${_userProfile?.coinWallet ?? 0} xu'),
              _buildInfoItem('Số xu đã tiêu', '${_userProfile?.coinSpent ?? 0} xu'),
              _buildInfoItem(
                  'Tình trạng Premium', _userProfile?.dayLeft ?? 'Bạn chưa mua gói premium'),
              if (_userProfile?.selectedGenreIds?.isNotEmpty ?? false) ...[
                Divider(color: Colors.grey[800], height: 32),
                _buildSectionHeader('Thể loại và sở thích'),
                _buildGenreList(_userProfile!.selectedGenreIds!),
              ],
              if (_userProfile?.hobbyNames?.isNotEmpty ?? false) ...[
                SizedBox(height: 16),
                _buildHobbyList(_userProfile!.hobbyNames!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGenreList(List<int> genreIds) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genreIds.map((id) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.greenAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
        ),
        child: Text(
          'ID: $id',
          style: TextStyle(color: Colors.greenAccent),
        ),
      )).toList(),
    );
  }
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(width: 16),
          // Bọc trong Expanded để Text có thể tự động xuống dòng
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,  // Tự động xuống dòng khi văn bản quá dài
              overflow: TextOverflow.visible, // Đảm bảo không có dấu ba chấm
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHobbyList(List<String> hobbies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sở thích',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: hobbies.map((hobby) => Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.5)),
            ),
            child: Text(
              hobby,
              style: TextStyle(color: Colors.blue[300]),
            ),
          )).toList(),
        ),
      ],
    );
  }
}