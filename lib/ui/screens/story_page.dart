import 'package:flutter/material.dart';
import 'package:test_app/ui/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:math' as math;
import 'dart:async';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late VideoPlayerController controller;
  late dynamic story;
  late List<int> storyLengths;
  late int storyNumber;

  final List<Map> _stories = [
    {
      'stories': [
        {
          'type': 'photo',
          'src': 'assets/stories/2.png',
          'time': '15h',
        },
        {
          'type': 'video',
          'src': 'assets/videos/2.mp4',
          'time': '13h',
        }
      ],
      'name': 'Erke Canbazoğlu',
      'avatar': 'assets/avatars/2.png'
    },
    {
      'stories': [
        {
          'type': 'photo',
          'src': 'assets/stories/3.png',
          'time': '18h',
        },
        {
          'type': 'video',
          'src': 'assets/videos/3.mp4',
          'time': '17h',
        }
      ],
      'name': 'Dos Santos',
      'avatar': 'assets/avatars/3.png'
    },
    {
      'stories': [
        {
          'type': 'photo',
          'src': 'assets/stories/4.png',
          'time': '13h',
        }
      ],
      'name': 'Mauro Icardi',
      'avatar': 'assets/avatars/4.png'
    }
  ];

  void initTimer(Map story) async {
    dynamic duration;
    if (story["type"] == "photo") {
      duration = const Duration(seconds: 5);
    } else {
      duration = const Duration(seconds: 5);
    }
    Timer.periodic(duration, (Timer timer) {
      if (mounted) {
        //Handle progress bar
        setState(() {
          DateTime.now();
        });
      }
    });
  }

  // int getVideoLength(Map video) {
  //   late VideoPlayerController tempController;
  //   tempController = VideoPlayerController.asset(video["src"])
  //     ..initialize().then((_) {
  //       final duration = tempController.value.duration;
  //       return duration.inMilliseconds;
  //     });
  // }

  // void handleStories(List<Map> stories) {
  //   storyNumber = stories.length;
  //   for (var i = 0; i < _stories.length; i++) {
  //     storyLengths[i] =
  //         stories[i]["type"] == "video" ? getVideoLength(stories[i]) : 5000;
  //     print(storyLengths[i]);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    story = _stories[0];
    // handleStories(story["stories"]);
    // controller = VideoPlayerController.asset('assets/videos/1.mp4')
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //     controller.play();
    //   });
    /* Network Player Example */
    controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Stack(
        children: [
          VideoPlayerWidget(controller: controller),
          // Center(
          //   child: SizedBox(
          //     height: double.infinity,
          //     // width: double.infinity,
          //     child: Image.asset(
          //       'assets/stories/2.png',
          //       // 'assets/posts/1.jpg',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage('assets/avatars/2.jpg'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "Erke Canbazoğlu",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "  15h",
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: InkWell(
                                  child: const Icon(Icons.more_horiz_outlined),
                                  onTap: () {
                                    //Settings
                                  },
                                ),
                              ),
                              InkWell(
                                child: const Icon(Icons.close),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  borderSide: BorderSide(
                                    color: Colors.white70,
                                    width: 1.0,
                                  ),
                                ),
                                filled: true,
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                                hintText: "Send message",
                                fillColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                              onTap: () {
                                //Like
                              },
                            ),
                          ),
                          Transform.rotate(
                            angle: -math.pi / 7,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                child: const Icon(
                                  Icons.send_outlined,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  //Send the post
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Building the full screen video
  Widget buildFullScreen({
    @required Widget? child,
  }) {
    final size = controller.value.size;
    final width = size.width;
    final height = size.height;

    return SizedBox(
      height: height,
      width: width,
      child: child,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
