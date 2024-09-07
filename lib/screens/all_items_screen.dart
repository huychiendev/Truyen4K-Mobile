import 'package:flutter/material.dart';

class AllItemsScreen extends StatelessWidget {
  final List<dynamic> items;
  final String category; // Thêm tham số category

  const AllItemsScreen({Key? key, required this.items, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category'), // Hiển thị danh sách theo loại đã chọn
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              //_buildItemList(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildItemList() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Danh Sách Các Mục - $category', // Hiển thị tiêu đề cùng loại đã chọn
  //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(height: 10),
  //       ListView.builder(
  //         physics: NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         itemCount: items.length,
  //         itemBuilder: (context, index) {
  //           final item = items[index] as Map<String, dynamic>;
  //           return ListTile(
  //             title: Text(item['title'] ?? 'Không có tiêu đề'),
  //             subtitle: Text(item['subtitle'] ?? ''),
  //             onTap: () {
  //               // Xử lý khi nhấn vào một mục cụ thể
  //               print('Bạn đã chọn ${item['title']}');
  //             },
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }
}
