import 'package:flutter/material.dart';

class PersonalProfileScreen extends StatefulWidget {
  @override
  _PersonalProfileScreenState createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  // Controllers to handle text input
  final TextEditingController _nameController = TextEditingController(text: 'LVuxyz');
  final TextEditingController _emailController = TextEditingController(text: 'lvu.byte@gmail.com');
  final TextEditingController _dobController = TextEditingController(text: '19 September, 2003');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Hồ Sơ',
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hồ sơ của bạn',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/avt.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Thay đổi ảnh hồ sơ',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              SizedBox(height: 20),

              // Text titles and editable fields
              Text(
                'Tên của bạn',
                style: TextStyle(color: Colors.white),
              ),
              ProfileInfoTile(
                child: TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Text(
                'Email',
                style: TextStyle(color: Colors.white),
              ),
              ProfileInfoTile(
                child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Text(
                'Ngày sinh',
                style: TextStyle(color: Colors.white),
              ),
              ProfileInfoTile(
                child: TextFormField(
                  controller: _dobController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  child: Text('Lưu Thông Tin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () {
                    // Handle save action
                    print('Saved Name: ${_nameController.text}');
                    print('Saved Email: ${_emailController.text}');
                    print('Saved Date of Birth: ${_dobController.text}');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final Widget child;

  const ProfileInfoTile({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: child, // Editable field
    );
  }
}
