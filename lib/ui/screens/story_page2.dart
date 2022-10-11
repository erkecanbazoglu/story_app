import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_app/ui/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import 'dart:async';
import '../../data/models/user.dart';
import '../widgets/progress_bars.dart';
import '../widgets/animated_bar.dart';

class StoryPage2 extends StatefulWidget {
  final List<Story> stories;

  const StoryPage2({Key? key, required this.stories}) : super(key: key);

  @override
  State<StoryPage2> createState() => _StoryPage2State();
}

class _StoryPage2State extends State<StoryPage2>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late VideoPlayerController _videoController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  List<double> percentWatched = [];
  Timer? timer;
  int milliseconds = 5000;
  double? screenWidth;
  double? dx;

  void _startStory({Story? story, bool shouldAnimate = true}) {
    //Stop the animation and reset the animation bar
    _animationController.stop();
    _animationController.reset();

    switch (story?.media) {
      case MediaType.image:
        //Set the image duration and start the animation
        _animationController.duration = story?.duration;
        _animationController.forward();
        break;
      case MediaType.video:
        //Initialize the video controller
        _videoController =
            VideoPlayerController.network(story?.url ?? "deafult")
              ..initialize().then((_) {
                setState(() {});
                if (_videoController.value.isInitialized) {
                  //Set the video duration and start the animation
                  _animationController.duration =
                      _videoController.value.duration;
                  _videoController.play();
                  _animationController.forward();
                }
              });
        break;
    }
    if (shouldAnimate) {
      _pageController.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
    }
  }

  //Gesture Functions
  void _onTapDown(TapDownDetails details) {
    screenWidth = MediaQuery.of(context).size.width;
    dx = details.globalPosition.dx;
    print(dx);
    print(screenWidth);
  }

  void _onLongPressCancel() {
    print(dx);
    print(screenWidth);
    if ((dx ?? 1) < (screenWidth ?? 400) / 3) {
      setState(() {
        if (_currentIndex > 0) {
          percentWatched[_currentIndex] = 0;
          percentWatched[_currentIndex - 1] = 0;
          _currentIndex--;
          _startStory(story: widget.stories[_currentIndex]);
        } else {
          percentWatched[_currentIndex] = 0;
        }
      });
    } else {
      setState(() {
        if (_currentIndex < widget.stories.length - 1) {
          percentWatched[_currentIndex] = 1;
          _currentIndex++;
          _startStory(story: widget.stories[_currentIndex]);
        } else {
          percentWatched[_currentIndex] = 1;
        }
      });
    }
  }

  void _onLongPress(story) {
    if (story.media == MediaType.video) {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _animationController.stop();
      }
    }
  }

  void _onLongPressEnd(story) {
    if (story.media == MediaType.video) {
      _videoController.play();
      _animationController.forward();
    }
  }

  void initVideoController(List<Story> stories) {
    //This function detects the first video story
    for (int i = 0; i < stories.length; i++) {
      if (stories[i].media == MediaType.video) {
        _videoController = VideoPlayerController.network(stories[i].url)
          ..initialize().then((_) {
            setState(() {});
          });
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);

    //The very first story
    final Story initialStory = widget.stories[0];

    //To make video controller initialized
    initVideoController(widget.stories);

    //Starting the stories
    _startStory(story: initialStory, shouldAnimate: false);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          if (_currentIndex + 1 < widget.stories.length) {
            _currentIndex++;
            _startStory(story: widget.stories[_currentIndex]);
          } else {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Stack(
        children: [
          GestureDetector(
            //get the click event
            onTapDown: (details) => _onTapDown(details),
            //pause the story
            onLongPress: () => _onLongPress(widget.stories[_currentIndex]),
            //next or previous story (continue onTapDown)
            onLongPressCancel: () => _onLongPressCancel(),
            //continue the story
            onLongPressEnd: (_) =>
                _onLongPressEnd(widget.stories[_currentIndex]),
            child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.stories.length,
                itemBuilder: (context, index) {
                  final story = widget.stories[index];
                  switch (story.media) {
                    case MediaType.image:
                      return CachedNetworkImage(
                        imageUrl: story.url,
                        fit: BoxFit.cover,
                      );
                    case MediaType.video:
                      if (_videoController != null &&
                          _videoController.value.isInitialized) {
                        return VideoPlayerWidget(controller: _videoController);
                      }
                      break;
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: widget.stories
                      .asMap()
                      .map((index, storyItem) {
                        return MapEntry(
                          index,
                          AnimatedBar(
                            animationController: _animationController,
                            position: index,
                            currentIndex: _currentIndex,
                          ),
                        );
                      })
                      .values
                      .toList(),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                              backgroundImage:
                                  AssetImage('assets/avatars/2.jpg'),
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
                                        child: const Icon(
                                            Icons.more_horiz_outlined),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _videoController.dispose();
    super.dispose();
  }
}
