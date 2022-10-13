// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:test_app/ui/widgets/video_player_widget.dart';
// import 'package:video_player/video_player.dart';
// import 'dart:math' as math;
// import 'dart:async';
// import '../../data/models/user.dart';
// import '../widgets/progress_bars.dart';
//
// class StoryPage extends StatefulWidget {
//   final List<Story> stories;
//
//   const StoryPage({Key? key, required this.stories}) : super(key: key);
//
//   @override
//   State<StoryPage> createState() => _StoryPageState();
// }
//
// class _StoryPageState extends State<StoryPage> {
//   late PageController _pageController;
//   late VideoPlayerController _videoController;
//   int _currentIndex = 0;
//   List<double> percentWatched = [];
//   Timer? timer;
//   int milliseconds = 5000;
//   double? screenWidth;
//   double? dx;
//
//   int get _getStoryDuration {
//     //Return story duration in milliseconds
//     if (widget.stories[_currentIndex].media == (MediaType.video)) {
//       Duration videoDuration = _videoController.value.duration;
//       return videoDuration.inMilliseconds;
//     } else {
//       return 5000;
//     }
//   }
//
//   void _startStories() {
//     int storyDuration = (_getStoryDuration / 10).round();
//     timer = Timer.periodic(Duration(milliseconds: 50), (_) {
//       setState(() {
//         // only add 0.01 as long as it's below 1
//         if (percentWatched[_currentIndex] + 0.01 < 1) {
//           percentWatched[_currentIndex] += 0.01;
//         }
//         // if adding 0.01 exceeds 1, set percentage to 1 and cancel timer
//         else {
//           percentWatched[_currentIndex] = 1;
//           timer?.cancel();
//
//           // also go to next story as long as there are more stories to go through
//           if (_currentIndex < widget.stories.length - 1) {
//             _currentIndex++;
//             animateToStory(_currentIndex);
//             // restart story timer
//             _startStories();
//           }
//           // if we are finishing the last story then return to homepage
//           else {
//             Navigator.pop(context);
//           }
//         }
//       });
//     });
//   }
//
//   //Gesture Functions
//   void _onTapDown(TapDownDetails details) {
//     screenWidth = MediaQuery.of(context).size.width;
//     dx = details.globalPosition.dx;
//   }
//
//   void _onLongPressCancel() {
//     if ((dx ?? 1) < (screenWidth ?? 400) / 3) {
//       setState(() {
//         if (_currentIndex > 0) {
//           percentWatched[_currentIndex] = 0;
//           percentWatched[_currentIndex - 1] = 0;
//           _currentIndex--;
//           animateToStory(_currentIndex);
//         } else {
//           percentWatched[_currentIndex] = 0;
//         }
//       });
//     } else {
//       setState(() {
//         if (_currentIndex < widget.stories.length - 1) {
//           percentWatched[_currentIndex] = 1;
//           _currentIndex++;
//           animateToStory(_currentIndex);
//         } else {
//           percentWatched[_currentIndex] = 1;
//         }
//       });
//     }
//   }
//
//   void _onLongPress(story) {
//     if (story.media == MediaType.video) {
//       if (_videoController.value.isPlaying) {
//         _videoController.pause();
//       }
//       // //might not be necessary
//       // else {
//       //   _videoController.play();
//       // }
//     }
//   }
//
//   void _onLongPressEnd(story) {
//     if (story.media == MediaType.video) {
//       _videoController.play();
//     }
//   }
//
//   void animateToStory(index) {
//     _pageController.animateToPage(index,
//         duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _videoController = VideoPlayerController.network(widget.stories[2].url)
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//         _videoController.play();
//       });
//
//     //Make all the stories unwatched
//     for (int i = 0; i < widget.stories.length; i++) {
//       percentWatched.add(0);
//     }
//
//     _startStories();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey[100],
//       body: Stack(
//         children: [
//           GestureDetector(
//             //get the click event
//             onTapDown: (details) => _onTapDown(details),
//             //pause the story
//             onLongPress: () => _onLongPress(widget.stories[_currentIndex]),
//             //next or previous story (continue onTapDown)
//             onLongPressCancel: () => _onLongPressCancel(),
//             //continue the story
//             onLongPressEnd: (_) =>
//                 _onLongPressEnd(widget.stories[_currentIndex]),
//             child: PageView.builder(
//                 controller: _pageController,
//                 // physics: NeverScrollableScrollPhysics(),
//                 itemCount: widget.stories.length,
//                 itemBuilder: (context, index) {
//                   final story = widget.stories[index];
//                   switch (story.media) {
//                     case MediaType.image:
//                       return CachedNetworkImage(
//                         imageUrl: story.url,
//                         fit: BoxFit.cover,
//                       );
//                     case MediaType.video:
//                       if (_videoController != null &&
//                           _videoController.value.isInitialized) {
//                         return VideoPlayerWidget(controller: _videoController);
//                       }
//                       break;
//                   }
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     ProgressBars(
//                       percentWatched: percentWatched,
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const CircleAvatar(
//                               radius: 16,
//                               backgroundImage:
//                                   AssetImage('assets/avatars/2.jpg'),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 12),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   RichText(
//                                     text: const TextSpan(
//                                       style: TextStyle(color: Colors.black),
//                                       children: [
//                                         TextSpan(
//                                           text: "Erke Canbazoğlu",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         TextSpan(
//                                           text: "  15h",
//                                           style: TextStyle(
//                                             color: Colors.white60,
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(right: 12),
//                                       child: InkWell(
//                                         child: const Icon(
//                                             Icons.more_horiz_outlined),
//                                         onTap: () {
//                                           //Settings
//                                         },
//                                       ),
//                                     ),
//                                     InkWell(
//                                       child: const Icon(Icons.close),
//                                       onTap: () {
//                                         Navigator.pop(context);
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const Expanded(
//                               child: Align(
//                                 alignment: Alignment.bottomLeft,
//                                 child: SizedBox(
//                                   height: 40,
//                                   child: TextField(
//                                     maxLines: 1,
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(16.0)),
//                                         borderSide: BorderSide(
//                                           color: Colors.white70,
//                                           width: 1.0,
//                                         ),
//                                       ),
//                                       filled: true,
//                                       hintStyle: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 13,
//                                       ),
//                                       hintText: "Send message",
//                                       fillColor: Colors.transparent,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20),
//                                   child: InkWell(
//                                     child: const Icon(
//                                       Icons.favorite_border,
//                                       color: Colors.white,
//                                     ),
//                                     onTap: () {
//                                       //Like
//                                     },
//                                   ),
//                                 ),
//                                 Transform.rotate(
//                                   angle: -math.pi / 7,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(bottom: 8.0),
//                                     child: InkWell(
//                                       child: const Icon(
//                                         Icons.send_outlined,
//                                         color: Colors.white,
//                                       ),
//                                       onTap: () {
//                                         //Send the post
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _videoController.dispose();
//     timer?.cancel();
//     super.dispose();
//   }
// }
