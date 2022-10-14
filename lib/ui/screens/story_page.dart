import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import '../widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import 'dart:async';
import '../../constants/constants.dart';
import '../../data/models/story.dart';
import '../../data/models/user.dart';
import '../widgets/progress_bars.dart';
import '../widgets/animated_bar.dart';

class StoryPage2 extends StatefulWidget {
  final List<Story> stories;
  final int storyIndex;

  const StoryPage2({
    Key? key,
    required this.stories,
    required this.storyIndex,
  }) : super(key: key);

  @override
  State<StoryPage2> createState() => _StoryPage2State();
}

class _StoryPage2State extends State<StoryPage2>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late PageController _pageController;
  late VideoPlayerController _videoController;
  late AnimationController _animationController;
  CarouselSliderController _carouselController = CarouselSliderController();
  final GlobalKey _carouselKey = GlobalKey();
  late Story story;
  int _currentIndex = 0;
  late int _currentStory;
  double? screenWidth;
  double? dx;

  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  void cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      print('downloaded successfully done for $url');
    });
  }

  void _startStory(
      {StoryContent? storyContent, bool shouldAnimate = true}) async {
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
        final fileInfo = await checkCacheFor(storyContent!.url);
        if (fileInfo == null) {
          _videoController = VideoPlayerController.network(storyContent.url);
          _videoController.initialize().then((value) {
            cachedForUrl(storyContent.url);
            setState(() {
              if (_videoController.value.isInitialized) {
                //Set the video duration and start the animation
                _animationController.duration = _videoController.value.duration;
                _videoController.play();
                _animationController.forward();
              }
            });
          });
        } else {
          final file = fileInfo.file;
          _videoController = VideoPlayerController.file(file);
          _videoController.initialize().then((value) {
            setState(() {
              if (_videoController.value.isInitialized) {
                //Set the video duration and start the animation
                _animationController.duration = _videoController.value.duration;
                _videoController.play();
                _animationController.forward();
              }
            });
          });
        }
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

  void _moveToNewStory(int newStoryIndex) {
    _animationController.stop();
    _animationController.reset();

    setState(() {
      _currentIndex = 0;
      _currentStory = newStoryIndex;
      story = widget.stories[_currentStory];
      _carouselController;
      _startStory(
          storyContent: story.userStories[_currentIndex], shouldAnimate: false);
    });
  }

  //Gesture Functions
  void _onTapDown(TapDownDetails details) {
    screenWidth = MediaQuery.of(context).size.width;
    dx = details.globalPosition.dx;
    _pauseStory(story.userStories[_currentIndex]);
  }

  void _onTap() async {
    _animationController.stop();
    _animationController.reset();

    if (dx! < screenWidth! / 3) {
      if (_currentIndex > 0) {
        moveToPreviousStoryContent();
      } else {
        navigateToPreviousPage();
      }
    } else {
      if (_currentIndex < story.userStories.length - 1) {
        moveToNextStoryContent();
      } else {
        navigateToNextPage();
      }
    }
  }

  void moveToPreviousStoryContent() {
    _animationController.stop();
    _animationController.reset();

    setState(() {
      _currentIndex--;
      _startStory(storyContent: story.userStories[_currentIndex]);
    });
  }

  void moveToNextStoryContent() {
    _animationController.stop();
    _animationController.reset();

    setState(() {
      _currentIndex++;
      _startStory(storyContent: story.userStories[_currentIndex]);
    });
  }

  void navigateToPreviousPage() {
    _animationController.stop();
    _animationController.reset();

    if (_currentStory == 0) {
      Navigator.pop(context, _currentStory);
      return;
    }
    setState(() {
      _currentIndex = 0;
      _currentStory--;
      story = widget.stories[_currentStory];
      _carouselController.previousPage();
      _startStory(
          storyContent: story.userStories[_currentIndex], shouldAnimate: false);
    });
  }

  void navigateToNextPage() {
    _animationController.stop();
    _animationController.reset();
    initVideoController();

    if (_currentStory == widget.stories.length - 1) {
      Navigator.pop(context, _currentStory);
      return;
    }
    setState(() {
      _currentIndex = 0;
      _currentStory++;
      story = widget.stories[_currentStory];
      _carouselController.nextPage();
      _startStory(
          storyContent: story.userStories[_currentIndex], shouldAnimate: false);
    });
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

  void initVideoController() {
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
    WidgetsBinding.instance?.addObserver(this);
    story = widget.stories[widget.storyIndex];
    _currentStory = widget.storyIndex;

    _pageController = PageController();
    _animationController = AnimationController(vsync: this);

    //To make video controller initialized
    initVideoController();

    //The very first story
    final StoryContent initialStory = story.userStories[0];

    //Starting the stories
    _startStory(storyContent: initialStory, shouldAnimate: false);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_currentIndex + 1 < story.userStories.length) {
          moveToNextStoryContent();
        } else {
          navigateToNextPage();
        }
      }
    });
  }

  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _pauseStory(story);
    } else if (state == AppLifecycleState.resumed) {
      _continueStory(story);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.pop(context, _currentStory);
      },
      onDragStart: () => _pauseStory(story.userStories[_currentIndex]),
      onDragEnd: () => _continueStory(story.userStories[_currentIndex]),
      backgroundColor: Colors.white,
      direction: DismissiblePageDismissDirection.down,
      isFullScreen: true,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: CarouselSlider.builder(
          key: _carouselKey,
          controller: _carouselController,
          initialPage: widget.storyIndex,
          itemCount: widget.stories.length,
          unlimitedMode: false,
          slideTransform: const CubeTransform(),
          autoSliderTransitionCurve: Curves.easeInOut,
          autoSliderTransitionTime: const Duration(milliseconds: 300),
          onSlideChanged: (index) => _moveToNewStory(index),
          onSlideStart: () {
            _pauseStory(story.userStories[_currentIndex]);
          },
          onSlideEnd: () {
            _continueStory(story.userStories[_currentIndex]);
          },
          slideBuilder: (carouselIndex) {
            return Stack(
              children: [
                GestureDetector(
                  //get the very first tap event
                  onTapDown: (details) => _onTapDown(details),
                  //validate tap event
                  onTap: () => _onTap(),
                  //continue the story
                  onLongPressEnd: (_) =>
                      _continueStory(story.userStories[_currentIndex]),
                  child: Hero(
                    tag: widget.stories[carouselIndex].id,
                    child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: story.userStories.length,
                        itemBuilder: (context, storyIndex) {
                          // final story = getStory.userStories[index];
                          final story = widget
                              .stories[carouselIndex].userStories[storyIndex];
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Row(
                          children: story.userStories
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
                                  CachedNetworkImage(
                                    imageUrl: story.user.profileImage,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // CircleAvatar(
                                  //   radius: 16,
                                  //   backgroundImage:
                                  //       NetworkImage(story.user.profileImage),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style:
                                                TextStyle(color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: story.user.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const TextSpan(
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
                                              Navigator.pop(
                                                  context, _currentStory);
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
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
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
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _videoController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
