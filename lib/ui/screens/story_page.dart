import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import '../../services/shared_preferences.dart';
import '../widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math' as math;
import 'dart:async';
import '../../data/models/story.dart';
import '../widgets/animated_bar.dart';

class StoryPage extends StatefulWidget {
  final List<Story> stories;
  final int storyIndex;

  const StoryPage({
    Key? key,
    required this.stories,
    required this.storyIndex,
  }) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late PageController _pageController;
  late VideoPlayerController _videoController;
  late AnimationController _animationController;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final GlobalKey _carouselKey = GlobalKey();
  late Story story;
  int _currentIndex = 0;
  late int _currentStory;
  double? screenWidth;
  double? dx;

  ///Checking for video cache
  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  ///Caches the videos if not cached
  void cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      print('downloaded successfully done for $url');
    });
  }

  ///Plays the Story Content
  void _playStory(
      {StoryContent? storyContent, bool shouldAnimate = true}) async {
    //Stop the animation and reset the animation bar
    _animationController.stop();
    _animationController.reset();

    SharedPreferencesService.setStoryContentSeen(storyContent!.id);
    storyContent.contentSeen = true;

    switch (storyContent.media) {
      case MediaType.image:
        //Set the image duration and start the animation
        _animationController.duration = storyContent.duration;
        _animationController.forward();
        break;
      case MediaType.video:
        final fileInfo = await checkCacheFor(storyContent.url);
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

  ///Move to new story after carousel page slide
  void _moveToNewStory(int newStoryIndex) {
    _animationController.stop();
    _animationController.reset();

    setState(() {
      _currentIndex = 0;
      _currentStory = newStoryIndex;
      story = widget.stories[_currentStory];
      _carouselController;
      _playStory(
          storyContent: story.userStories[_currentIndex], shouldAnimate: false);
    });
  }

  ///esture Function: Initial tap move
  void _onTapDown(TapDownDetails details) {
    screenWidth = MediaQuery.of(context).size.width;
    dx = details.globalPosition.dx;
    _pauseStory(story.userStories[_currentIndex]);
  }

  ///Gesture Function: Tap confirmed
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

  ///Moves to the Previous Story Content
  void moveToPreviousStoryContent() {
    _animationController.stop();
    _animationController.reset();

    setState(() {
      _currentIndex--;
      _playStory(storyContent: story.userStories[_currentIndex]);
    });
  }

  ///Moves to the Next Story Content
  void moveToNextStoryContent() {
    _animationController.stop();
    _animationController.reset();

    setState(() {
      _currentIndex++;
      _playStory(storyContent: story.userStories[_currentIndex]);
    });
  }

  ///Moves to the Previous Story
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
      _playStory(
          storyContent: story.userStories[_currentIndex], shouldAnimate: false);
    });
  }

  ///Moves to the Next Story
  void navigateToNextPage() {
    _animationController.stop();
    _animationController.reset();
    // initVideoController();

    if (_currentStory == widget.stories.length - 1) {
      Navigator.pop(context, _currentStory);
      return;
    }
    setState(() {
      _currentIndex = 0;
      _currentStory++;
      story = widget.stories[_currentStory];
      _carouselController.nextPage();
      _playStory(
          storyContent: story.userStories[_currentIndex], shouldAnimate: false);
    });
  }

  ///Pause the Story Content
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

  ///Resume the Story Content
  void _resumeStory(story) {
    if (story.media == MediaType.video) {
      _videoController.play();
      _animationController.forward();
    } else {
      _animationController.forward();
    }
  }

  ///Initializing the video controller
  ///If not problem occurs on dispose
  void initVideoController() {
    if (story.userStories[_currentIndex].media == MediaType.video) {
      _videoController =
          VideoPlayerController.network(story.userStories[_currentIndex].url)
            ..initialize().then((_) {
              setState(() {});
            });
    } else {
      _videoController = VideoPlayerController.network(
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4")
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  ///Gets the first unseen Story Content
  void getInitialUnseenIndex() {
    for (int i = 0; i < story.userStories.length; i++) {
      if (story.userStories[i].contentSeen == false) {
        _currentIndex = i;
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    ///For getting the app lifecycle
    WidgetsBinding.instance?.addObserver(this);

    ///Getting the initial story
    _currentStory = widget.storyIndex;
    story = widget.stories[widget.storyIndex];

    ///Getting the first unseen story content
    getInitialUnseenIndex();

    ///Controller initialization
    _pageController = PageController(initialPage: _currentIndex);
    _animationController = AnimationController(vsync: this);

    ///Video controller initialized
    initVideoController();

    //The very first story
    final StoryContent initialStory = story.userStories[_currentIndex];

    //Starting the stories
    _playStory(storyContent: initialStory, shouldAnimate: false);

    ///Animation Controller listener (for auto page slides)
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

  ///Getting and acting according to the app lifecycle
  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _pauseStory(story.userStories[_currentIndex]);
    } else if (state == AppLifecycleState.resumed) {
      _resumeStory(story.userStories[_currentIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.pop(context, _currentStory);
      },
      onDragStart: () => _pauseStory(story.userStories[_currentIndex]),
      onDragEnd: () => _resumeStory(story.userStories[_currentIndex]),
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
          onSlideStart: () => _pauseStory(story.userStories[_currentIndex]),
          onSlideEnd: () => _resumeStory(story.userStories[_currentIndex]),
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
                      _resumeStory(story.userStories[_currentIndex]),
                  child: Hero(
                      tag: widget.stories[carouselIndex].id,
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: story.userStories.length,
                        itemBuilder: (context, storyIndex) {
                          // final story = getStory.userStories[index];
                          final storyContent = widget
                              .stories[carouselIndex].userStories[storyIndex];
                          switch (storyContent.media) {
                            case MediaType.image:
                              return CachedNetworkImage(
                                imageUrl: storyContent.url,
                                fit: BoxFit.cover,
                              );
                            case MediaType.video:
                              if (_videoController.value.isInitialized) {
                                return VideoPlayerWidget(
                                    controller: _videoController);
                              }
                              break;
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )),
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
                                    imageUrl: widget.stories[carouselIndex].user
                                        .profileImage,
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
                                                text: widget
                                                    .stories[carouselIndex]
                                                    .user
                                                    .name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '  ${widget.stories[carouselIndex].userStories[_currentIndex].sentTimestamp.toString()}h',
                                                style: const TextStyle(
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
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: SizedBox(
                                        height: 40,
                                        child: TextField(
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16.0)),
                                              borderSide: BorderSide(
                                                color: Colors.white70,
                                                width: 1.0,
                                              ),
                                            ),
                                            filled: true,
                                            hintStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .sendMessage,
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
