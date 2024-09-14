import 'package:flutter/material.dart';

class PersonalProfileScreen extends StatefulWidget {
  @override
  _PersonalProfileScreenState createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool _isDefaultImage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hồ Sơ',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hồ sơ của bạn',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(_isDefaultImage ? 'assets/avt.png' : 'assets/avt_alternative.png'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _changeProfilePicture,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                child: Icon(Icons.edit, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: _changeProfilePicture,
                        child: Text('Thay đổi ảnh hồ sơ', style: TextStyle(color: Colors.green)),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField('Tên của bạn', 'Nhập tên của bạn', _nameController),
                    SizedBox(height: 20),
                    _buildTextField('Email', 'Nhập email của bạn', _emailController),
                    SizedBox(height: 20),
                    _buildTextField('Ngày sinh', 'Nhập ngày sinh của bạn', _dobController),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        child: Text('Lưu Thông Tin'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        onPressed: _saveProfile,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
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
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white54),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }

  void _changeProfilePicture() {
    setState(() {
      _isDefaultImage = !_isDefaultImage;
    });
  }

  void _saveProfile() {
  print('Saved Name: ${_nameController.text}');
  print('Saved Email: ${_emailController.text}');
  print('Saved Date of Birth: ${_dobController.text}');
  print('Profile Picture: ${_isDefaultImage ? "Default" : "Alternative"}');

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Thông tin đã được lưu thành công!'),
      backgroundColor: Colors.green,
    ),
  );
}
}