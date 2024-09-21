// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:apptruyenonline/screens/menu/audio_player_provider.dart';
// import 'package:apptruyenonline/screens/item_truyen/view_screen/miniplayer.dart';
//
// class PersistentMiniPlayer extends StatelessWidget {
//   final Widget child;
//
//   const PersistentMiniPlayer({Key? key, required this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AudioPlayerProvider>(
//       builder: (context, audioPlayerProvider, _) {
//         return Stack(
//           children: [
//             child,
//             if (audioPlayerProvider.showMiniPlayer)
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: MiniPlayer(
//                   title: audioPlayerProvider.currentTitle,
//                   artist: audioPlayerProvider.currentArtist,
//                   imageUrl: audioPlayerProvider.currentImageUrl,
//                   isPlaying: audioPlayerProvider.isPlaying,
//                   onTap: () {
//                     // Implement navigation to full player screen if needed
//                     print('MiniPlayer tapped');
//                   },
//                   onPlayPause: () {
//                     audioPlayerProvider.togglePlayPause();
//                   },
//                   onNext: () {
//                     audioPlayerProvider.nextTrack();
//                   },
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }