// import 'package:flutter/material.dart';
//
// class BookScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 200,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text('Book Details'),
//               background: Image.network(
//                 'assets/metruyen.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Image.network(
//                       'https://example.com/book_cover.jpg',
//                       height: 200,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Tận Thế Tháp Phòng: Phòng Ngự Của Ta Thấp Quá Mức Cần Thận!',
//                     style: Theme.of(context).textTheme.headlineSmall, // Updated from headline6 to headlineSmall
//                   ),
//                   Text('Nhữ Hữu Thần Trư'),
//                   Text('1900 Chương'),
//                   SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {},
//                         child: Text('Đọc Truyện'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {},
//                         child: Text('Nghe Truyện'),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Ngày tận thế khi, mỗi người trưởng thành đều phải tiến vào tháp phòng thủ giới ngăn cản Zombie xâm lược...',
//                     style: Theme.of(context).textTheme.bodyText2,
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Chapters',
//                     style: Theme.of(context).textTheme.headlineSmall, // Updated from headline6 to headlineSmall
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                 return ListTile(
//                   title: Text('Chapter ${index + 1}'),
//                   trailing: IconButton(
//                     icon: Icon(Icons.play_arrow),
//                     onPressed: () {},
//                   ),
//                 );
//               },
//               childCount: 56,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
