// import 'package:flutter/material.dart';
//
// class UserAccountScreen extends StatelessWidget {
//   final String username;
//   final String email;
//   final String avatarUrl;
//   final int dailyTaskCount;
//   final double experiencePoints;
//   final VoidCallback onWalletTap;
//   final VoidCallback onDailyTasksTap;
//
//   const UserAccountScreen({
//     Key? key,
//     required this.username,
//     required this.email,
//     required this.avatarUrl,
//     required this.dailyTaskCount,
//     required this.experiencePoints,
//     required this.onWalletTap,
//     required this.onDailyTasksTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text('Tài Khoản'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildUserHeader(),
//             _buildAccountFeatures(),
//             _buildDailyActivities(),
//             _buildMyPrivileges(),
//             _buildFeedbackSection(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavigation(),
//     );
//   }
//
//   Widget _buildUserHeader() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundImage: NetworkImage(avatarUrl),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   username,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   email,
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAccountFeatures() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.amber[800],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Truyện 247 vip',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Xem chi tiết',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildFeatureButton(
//                   icon: Icons.account_balance_wallet,
//                   label: 'Cái ví',
//                   onTap: onWalletTap,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: _buildFeatureButton(
//                   icon: Icons.shopping_bag,
//                   label: 'Túi',
//                   onTap: () {},
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFeatureButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.grey[900],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white),
//             SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDailyActivities() {
//     return InkWell(
//       onTap: onDailyTasksTap,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.grey[900],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Điểm danh hàng ngày',
//               style: TextStyle(color: Colors.white),
//             ),
//             Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMyPrivileges() {
//     final privileges = [
//       {'icon': Icons.person, 'title': 'User level'},
//       {'icon': Icons.event, 'title': 'Sự kiện'},
//       {'icon': Icons.app_registration, 'title': 'Đăng ký'},
//       {'icon': Icons.star, 'title': 'Tương thành tựu'},
//     ];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Text(
//             'Đặc quyền của tôi',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         Container(
//           height: 100,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: privileges.map((item) => _buildPrivilegeItem(
//               item['icon'] as IconData,
//               item['title'] as String,
//             )).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPrivilegeItem(IconData icon, String title) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.grey[850],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: Colors.white),
//         ),
//         SizedBox(height: 8),
//         Text(
//           title,
//           style: TextStyle(color: Colors.grey, fontSize: 12),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFeedbackSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16),
//           child: Text(
//             'Phản hồi',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         ListTile(
//           leading: Icon(Icons.help_outline, color: Colors.white),
//           title: Text(
//             'Trợ giúp và phản hồi',
//             style: TextStyle(color: Colors.white),
//           ),
//           trailing: Icon(Icons.chevron_right, color: Colors.grey),
//           onTap: () {},
//         ),
//         ListTile(
//           leading: Icon(Icons.star_border, color: Colors.white),
//           title: Text(
//             'Đánh giá',
//             style: TextStyle(color: Colors.white),
//           ),
//           trailing: Icon(Icons.chevron_right, color: Colors.grey),
//           onTap: () {},
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBottomNavigation() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black,
//         border: Border(
//           top: BorderSide(color: Colors.grey[900]!),
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(Icons.home, 'Trang chủ'),
//             _buildNavItem(Icons.search, 'Khám phá'),
//             _buildNavItem(Icons.library_books, 'Thư viện'),
//             _buildNavItem(Icons.person, 'Tôi', isSelected: true),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           icon,
//           color: isSelected ? Colors.green : Colors.grey,
//         ),
//         SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.green : Colors.grey,
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }
// }