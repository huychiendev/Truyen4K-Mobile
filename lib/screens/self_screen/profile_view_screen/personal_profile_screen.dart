import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/User.dart';
import '../../../services/auth_service.dart';
import 'package:http/http.dart' as http;

class PersonalProfileScreen extends StatefulWidget {
  @override
  _PersonalProfileScreenState createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  UserImage? _userImage;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');
    print('Token: $token');
    print('User ID: $userId');

    if (token != null && userId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/images/?userId=$userId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> imageData = json.decode(response.body);
          if (imageData.isNotEmpty) {
            UserImage userImage = UserImage.fromJson(imageData[0]);
            setState(() {
              _userImage = userImage;
            });
          } else {
            setState(() {
              _userImage = null;
            });
          }
        } else {
          setState(() {
            _userImage = null;
          });
          print('Failed to load image data');
        }
      } catch (e) {
        setState(() {
          _userImage = null;
        });
        print('Error: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      int? userId = prefs.getInt('user_id');

      if (token != null && userId != null) {
        await AuthService.uploadUserImage(token, userId, _selectedImage!);
        _fetchUserDetails();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Personal Profile'),
        backgroundColor: Colors.black,
      ),
      body: _userImage == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoField('Email', _userImage!.user.email),
                  _buildInfoField('Cấp độ', _userImage!.user.tierName ?? 'N/A'),
                  _buildInfoField(
                      'Vai trò',
                      _userImage!.user.roles
                              .map((role) => role.name)
                              .join(', ') ??
                          'N/A'),
                  _buildInfoField('Số chương đã đọc',
                      _userImage!.user.chapterReadCount.toString() ?? '0'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadImage,
                    child: Text('Upload Image'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        SizedBox(height: 8),
        Container(
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(value, style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
