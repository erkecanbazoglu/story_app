import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_app/ui/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import 'dart:async';
import '../../constants/constants.dart';
import '../../data/models/story.dart';
import '../../data/models/user.dart';
import '../widgets/progress_bars.dart';
import '../widgets/animated_bar.dart';

class StoryPage2 extends StatefulWidget {
  final Story story;

  const StoryPage2({Key? key, required this.story}) : super(key: key);

  @override
  State<StoryPage2> createState() => _StoryPage2State();
}

class _StoryPage2State extends State<StoryPage2>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late VideoPlayerController _videoController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  double? screenWidth;
  double? dx;

  void _startStory({StoryContent? storyContent, bool shouldAnimate = true}) {
    //Stop the animation and reset the animation bar
    _animationController.stop();
    _animationController.reset();

    switch (storyContent?.media) {
      case MediaType.image:
        //Set the image duration and start the animation
        _animationController.duration = storyContent?.duration;
        _animationController.forward();
        break;
      case MediaType.video:
        //Initialize the video controller
        _videoController =
            VideoPlayerController.network(storyContent?.url ?? "deafult")
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
      default:
        _animationController.forward();
        break;
    }
    if (shouldAnimate) {
      _pageController.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
    }
  }

  //Gesture Functions
  void _onLongPressDown(LongPressDownDetails details) {
    screenWidth = MediaQuery.of(context).size.width;
    dx = details.globalPosition.dx;
  }

  void _onLongPressCancel() {
    if (dx! < screenWidth! / 3) {
      if (_currentIndex > 0) {
        setState(() {
          _currentIndex--;
          _startStory(storyContent: widget.story.userStories[_currentIndex]);
        });
      } else {
        setState(() {
          _startStory(storyContent: widget.story.userStories[_currentIndex]);
        });
      }
    } else {
      if (_currentIndex < widget.story.userStories.length - 1) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          _currentIndex++;
          _startStory(storyContent: widget.story.userStories[_currentIndex]);
        });
      } else {
        ///Next Story
        //Navigator.pop for now
        Navigator.pop(context);
      }
    }
  }

  void _pauseStory(story) {
    if (story.media == MediaType.video) {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _animationController.stop();
      }
    } else {
      _animationController.stop();
    }
  }

  void _continueStory(story) {
    if (story.media == MediaType.video) {
      _videoController.play();
      _animationController.forward();
    } else {
      _animationController.forward();
    }
  }

  void initVideoController(List<StoryContent> stories) {
    //This function detects the first video story
    // for (int i = 0; i < stories.length; i++) {
    //   if (stories[i].media == MediaType.video) {
    //     _videoController =
    //
    //           _videoController = VideoPlayerController.asset(stories[i].url)
    //           ..initialize().then((_) {
    //             setState(() {});
    //           });
    //     break;
    //   }
    // }
    _videoController = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4")
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);

    //The very first story
    final StoryContent initialStory = widget.story.userStories[0];

    //To make video controller initialized
    initVideoController(widget.story.userStories);

    //Starting the stories
    _startStory(storyContent: initialStory, shouldAnimate: false);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          if (_currentIndex + 1 < widget.story.userStories.length) {
            _currentIndex++;
            _startStory(storyContent: widget.story.userStories[_currentIndex]);
          } else {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).pop();
      },
      onDragStart: () => _pauseStory(widget.story.userStories[_currentIndex]),
      onDragEnd: () => _continueStory(widget.story.userStories[_currentIndex]),
      backgroundColor: Colors.white,
      direction: DismissiblePageDismissDirection.down,
      isFullScreen: true,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Stack(
          children: [
            GestureDetector(
              //get the very first press event
              onLongPressDown: (details) => _onLongPressDown(details),
              //next or previous story (move as click event)
              onLongPressCancel: () => _onLongPressCancel(),
              //pause the story
              onLongPress: () =>
                  _pauseStory(widget.story.userStories[_currentIndex]),
              //continue the story
              onLongPressEnd: (_) =>
                  _continueStory(widget.story.userStories[_currentIndex]),
              child: Hero(
                tag: widget.story.id,
                child: PageView.builder(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.story.userStories.length,
                    itemBuilder: (context, index) {
                      final story = widget.story.userStories[index];
                      switch (story.media) {
                        case MediaType.image:
                          return CachedNetworkImage(
                            imageUrl: story.url,
                            fit: BoxFit.cover,
                          );
                        case MediaType.video:
                          if (_videoController != null &&
                              _videoController.value.isInitialized) {
                            return VideoPlayerWidget(
                                controller: _videoController);
                          }
                          break;
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    children: widget.story.userStories
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
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
                                      InkWell(
                                        child: const Icon(
                                            Icons.more_horiz_outlined),
                                        onTap: () {
                                          //Settings
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                        ),
                                        onPressed: () {
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
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
