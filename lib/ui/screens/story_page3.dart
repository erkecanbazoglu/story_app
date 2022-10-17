import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:test_app/services/shared_preferences.dart';
import '../../logic/bloc/story/story_bloc.dart';
import '../../logic/bloc/story_content/story_content_bloc.dart';
import '../widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import 'dart:async';
import '../../constants/constants.dart';
import '../../data/models/story.dart';
import '../../data/models/user.dart';
import '../widgets/progress_bars.dart';
import '../widgets/animated_bar.dart';

class StoryPage3 extends StatefulWidget {
  final List<Story> stories;
  final int storyIndex;

  const StoryPage3({
    Key? key,
    required this.stories,
    required this.storyIndex,
  }) : super(key: key);

  @override
  State<StoryPage3> createState() => _StoryPage3State();
}

class _StoryPage3State extends State<StoryPage3>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // late PageController _pageController;
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

  void _playStory(
      {StoryContent? storyContent, bool shouldAnimate = true}) async {
    final storyBloc = BlocProvider.of<StoryBloc>(context);
    final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
    var storyState = storyBloc.state;
    var storyContentState = storyContentBloc.state;

    //Stop the animation and reset the animation bar
    _animationController.stop();
    _animationController.reset();

    SharedPreferencesService.setStoryContentSeen(storyContent!.id);

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
    // if (storyState is StoryOpened && storyContentState is StoryContentPlayed) {
    //   if (shouldAnimate) {
    //     _pageController.animateToPage(storyContentState.storyContentIndex,
    //         duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
    //   }
    // }
  }

  void _moveToNewStory(int newStoryIndex) {
    // _animationController.stop();
    // _animationController.reset();
    final storyBloc = BlocProvider.of<StoryBloc>(context);
    var storyState = storyBloc.state;

    if (storyState is StoryOpened) {
      setState(() {
        _carouselController;
      });
      _openStory(storyState.storyIndex);
      // storyBloc.add(NextStory(widget.stories, storyState.storyIndex + 1));
    }

    // setState(() {
    //   _currentIndex = 0;
    //   _currentStory = newStoryIndex;
    //   story = widget.stories[_currentStory];
    //   _carouselController;
    //   _playStory(
    //       storyContent: story.userStories[_currentIndex], shouldAnimate: false);
    // });
  }

  //Gesture Functions
  void _onTapDown(TapDownDetails details) {
    screenWidth = MediaQuery.of(context).size.width;
    dx = details.globalPosition.dx;

    final storyBloc = BlocProvider.of<StoryBloc>(context);
    final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
    var storyState = storyBloc.state;
    var storyContentState = storyContentBloc.state;

    if (storyState is StoryOpened && storyContentState is StoryContentPlayed) {
      _pauseStoryContent(storyState.story, storyContentState.storyContentIndex);
    }
    _pauseStory(story.userStories[_currentIndex]);
  }

  void _onTap() async {
    // _animationController.stop();
    // _animationController.reset();

    final storyBloc = BlocProvider.of<StoryBloc>(context);
    final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
    var storyState = storyBloc.state;
    var storyContentState = storyContentBloc.state;

    if (storyState is StoryOpened && storyContentState is StoryContentPlayed) {
      // _animationController.stop();
      // _animationController.reset();

      if (dx! < screenWidth! / 3) {
        if (_currentIndex > 0) {
          // _moveToPreviousStoryContent();
          _moveToPreviousStoryContent();
        } else {
          // _navigateToPreviousPage();
          _navigateToPreviousPage();
        }
      }
    } else {
      if (_currentIndex < story.userStories.length - 1) {
        // moveToNextStoryContent();
        print("this shouldnt work");
        _moveToNextStoryContent();
      } else {
        // _navigateToNextPage();
        _navigateToNextPage();
      }
    }
  }

  _closeStory() {
    final storyBloc = BlocProvider.of<StoryBloc>(context);
    var storyState = storyBloc.state;

    if (storyState is StoryOpened) {
      storyBloc.add(CloseStory(widget.stories, storyState.storyIndex));
      Navigator.pop(context, storyState.storyIndex);
    }
  }

  void _moveToPreviousStoryContent() {
    final storyBloc = BlocProvider.of<StoryBloc>(context);
    final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
    var storyState = storyBloc.state;
    var storyContentState = storyContentBloc.state;

    if (storyState is StoryOpened && storyContentState is StoryContentPlayed) {
      storyContentBloc.add(PreviousStoryContent(
          storyState.story, storyContentState.storyContentIndex - 1));
    }

    // _animationController.stop();
    // _animationController.reset();

    // setState(() {
    //   _currentIndex--;
    //   _playStory(storyContent: story.userStories[_currentIndex]);
    // });
  }

  void _moveToNextStoryContent() {
    final storyBloc = BlocProvider.of<StoryBloc>(context);
    final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
    var storyState = storyBloc.state;
    var storyContentState = storyContentBloc.state;

    if (storyState is StoryOpened && storyContentState is StoryContentPlayed) {
      storyContentBloc.add(NextStoryContent(
          storyState.story, storyContentState.storyContentIndex + 1));
    }
    // setState(() {
    //   _currentIndex++;
    //   _playStory(storyContent: story.userStories[_currentIndex]);
    // });
  }

  void _navigateToPreviousPage() {
    final storyBloc = BlocProvider.of<StoryBloc>(context);
    final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
    var storyState = storyBloc.state;
    var storyContentState = storyContentBloc.state;

    if (storyState is StoryOpened && storyContentState is StoryContentPlayed) {
      if (storyState.storyIndex == 0) {
        _closeStory();
        return;
      }
      _openStory(storyState.storyIndex - 1);
      _carouselController.previousPage(const Duration(milliseconds: 400));
      // storyBloc.add(PreviousStory(widget.stories, storyState.storyIndex - 1));
    }

    // _animationController.stop();
    // _animationController.reset();

    // if (_currentStory == 0) {
    //   Navigator.pop(context, _currentStory);
    //   return;
    // }
    // setState(() {
    //   _currentIndex = 0;
    //   _currentStory--;
    //   story = widget.stories[_currentStory];
    //   _carouselController.previousPage();
    //   _playStory(
    //       storyContent: story.userStories[_currentIndex], shouldAnimate: false);
    // });
  }

  void _navigateToNextPage() {
    final storyBloc = BlocProvider.of<StoryBloc>(context);
    var storyState = storyBloc.state;

    if (storyState is StoryOpened) {
      if (storyState.storyIndex == widget.stories.length - 1) {
        print("finished");
        _closeStory();
        // Navigator.pop(context, storyState.storyIndex);
        return;
      }
      _carouselController.nextPage();
      _openStory(storyState.storyIndex + 1);
      // storyBloc.add(NextStory(widget.stories, storyState.storyIndex + 1));
    }

    // _animationController.stop();
    // _animationController.reset();
    // _initControllers();

    // if (_currentStory == widget.stories.length - 1) {
    //   Navigator.pop(context, _currentStory);
    //   return;
    // }
    // setState(() {
    //   _currentIndex = 0;
    //   _currentStory++;
    //   story = widget.stories[_currentStory];
    //   _carouselController.nextPage();
    //   _playStory(
    //       storyContent: story.userStories[_currentIndex], shouldAnimate: false);
    // });
  }

  //New Functions

  void _pauseStory(StoryContent story) {
    if (story.media == MediaType.video) {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _animationController.stop();
      }
    } else {
      _animationController.stop();
    }
  }

  void _resumeStory(StoryContent story) {
    if (story.media == MediaType.video) {
      _videoController.play();
      _animationController.forward();
    } else {
      _animationController.forward();
    }
  }

  void _initControllers() {
    // _pageController = PageController();
    _animationController = AnimationController(vsync: this);
    _videoController = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4")
      ..initialize().then((_) {
        setState(() {});
      });

    _animationController.addStatusListener((status) {
      final storyBloc = BlocProvider.of<StoryBloc>(context);
      final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
      var storyState = storyBloc.state;
      var storyContentState = storyContentBloc.state;

      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();

        if (storyState is StoryOpened &&
            storyContentState is StoryContentPlayed) {
          if (storyContentState.storyContentIndex + 1 <
              storyState.story.userStories.length) {
            // moveToNextStoryContent();
            print("this line worked");
            _moveToNextStoryContent();
          } else {
            _navigateToNextPage();
          }
        }
      }
    });
  }

  void _openStory(int storyIndex) {
    final storyBloc = BlocProvider.of<StoryBloc>(context);
    storyBloc.add(OpenStory(widget.stories, storyIndex));
  }

  void _pauseStoryContent(Story story, int storyContentIndex) {
    final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
    storyContentBloc
        .add(PauseStoryContent(story, storyContentIndex, PlayState.paused));
  }

  void _resumeStoryContent(Story story, int storyContentIndex) {
    final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
    storyContentBloc
        .add(ResumeStoryContent(story, storyContentIndex, PlayState.resume));
  }

  void _playStoryContent(StoryContent storyContent, int storyContentIndex) {
    _playStory(
        storyContent: storyContent,
        shouldAnimate: storyContentIndex == 0 ? false : true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _currentStory = widget.storyIndex;

    story = widget.stories[0];

    //Controllers initialized
    _initControllers();

    //Open initial Story
    _openStory(widget.storyIndex);
  }

  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // _pauseStory(story);
    } else if (state == AppLifecycleState.resumed) {
      // _resumeStory(story);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: MultiBlocListener(
        listeners: [
          BlocListener<StoryBloc, StoryState>(
            listener: (context, state) {
              print("a");
              if (state is StoryOpened) {
                print("b");
                final storyContentBloc =
                    BlocProvider.of<StoryContentBloc>(context);
                storyContentBloc
                    .add(PlayStoryContent(state.story, 0, PlayState.begin));

                // playStoryContent(state.story);
                // playStoryContent(state.story);
              }
            },
          ),
          BlocListener<StoryContentBloc, StoryContentState>(
            listener: (context, state) {
              if (state is StoryContentPlayed) {
                print("called");
                if (state.playState == PlayState.begin) {
                  _playStoryContent(
                      state.storyContent, state.storyContentIndex);
                } else if (state.playState == PlayState.paused) {
                  _pauseStory(state.storyContent);
                } else if (state.playState == PlayState.resume) {
                  _resumeStory(state.storyContent);
                } else {
                  print("error");
                }
              }
            },
          ),
        ],
        child: BlocBuilder<StoryBloc, StoryState>(
          builder: (context, storyState) {
            if (storyState is StoryOpened) {
              print("Widget rebuild");
              return BlocBuilder<StoryContentBloc, StoryContentState>(
                builder: (context, storyContentState) {
                  if (storyContentState is StoryContentPlayed) {
                    return DismissiblePage(
                      onDismissed: () {
                        _closeStory();
                        // Navigator.pop(context, _currentStory);
                      },
                      onDragStart: () => _pauseStoryContent(storyState.story,
                          storyContentState.storyContentIndex),
                      onDragEnd: () => _resumeStoryContent(storyState.story,
                          storyContentState.storyContentIndex),
                      backgroundColor: Colors.white,
                      direction: DismissiblePageDismissDirection.down,
                      isFullScreen: true,
                      child: CarouselSlider.builder(
                        key: _carouselKey,
                        controller: _carouselController,
                        initialPage: widget.storyIndex,
                        itemCount: widget.stories.length,
                        unlimitedMode: false,
                        slideTransform: const CubeTransform(),
                        autoSliderTransitionCurve: Curves.easeInOut,
                        autoSliderTransitionTime:
                            const Duration(milliseconds: 300),
                        onSlideChanged: (index) => _moveToNewStory(index),
                        onSlideStart: () {
                          _pauseStoryContent(storyState.story,
                              storyContentState.storyContentIndex);
                        },
                        onSlideEnd: () {
                          _resumeStoryContent(storyState.story,
                              storyContentState.storyContentIndex);
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
                                onLongPressEnd: (_) => _resumeStoryContent(
                                    storyState.story,
                                    storyContentState.storyContentIndex),
                                child: Hero(
                                    tag: widget.stories[carouselIndex].id,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Builder(
                                        builder: (BuildContext context) {
                                          // final story = getStory.userStories[index];
                                          // final storyContent =
                                          //     storyContentState.storyContent;
                                          final storyContent = widget
                                              .stories[carouselIndex]
                                              .userStories[0];
                                          switch (storyContent.media) {
                                            case MediaType.image:
                                              return CachedNetworkImage(
                                                imageUrl: storyContent.url,
                                                fit: BoxFit.cover,
                                              );
                                            case MediaType.video:
                                              if (_videoController
                                                  .value.isInitialized) {
                                                return VideoPlayerWidget(
                                                    controller:
                                                        _videoController);
                                              }
                                              break;
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ),
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
                                                  animationController:
                                                      _animationController,
                                                  position: index,
                                                  currentIndex:
                                                      storyContentState
                                                          .storyContentIndex,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      story.user.profileImage,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          children: [
                                                            TextSpan(
                                                              text: story
                                                                  .user.name,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  '  ${storyState.story.userStories[storyContentState.storyContentIndex].sentTimestamp.toString()}h',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white60,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        InkWell(
                                                          child: const Icon(Icons
                                                              .more_horiz_outlined),
                                                          onTap: () {
                                                            //Settings
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.close,
                                                          ),
                                                          onPressed: () {
                                                            _closeStory();
                                                            // Navigator.pop(
                                                            //     context,
                                                            //     _currentStory);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: SizedBox(
                                                      height: 40,
                                                      child: TextField(
                                                        maxLines: 1,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        16.0)),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .white70,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          filled: true,
                                                          hintStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                          ),
                                                          hintText:
                                                              "Send message",
                                                          fillColor: Colors
                                                              .transparent,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
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
                                                            const EdgeInsets
                                                                    .only(
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
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            } else {
              return const Text("Story not opened");
            }
          },
        ),
      ),
    );
  }
  // listeners: [
  //   BlocListener<StoryBloc, StoryState>(
  //     listener: (storyContext, state) {
  //       //Play the Story at given Story index
  //       int storyContentIndex = 0;
  //       if (state is StoryOpened) {
  //         final storyContentBloc =
  //             BlocProvider.of<StoryContentBloc>(storyContext);
  //         ///TODO: Change here with dynamic index
  //         storyContentBloc
  //             .add(PlayStoryContent(state.story, storyContentIndex));
  //       } else if (state is StoryClosed) {
  //         Navigator.pop(context, state.storyIndex);
  //       }
  //     },
  //   ),
  //   BlocListener<StoryContentBloc, StoryContentState>(
  //     listener: (storyContentContext, state) {
  //       if (state is StoryContentPlayed) {
  //         if (state.playState == PlayState.begin) {
  //           state.storyContentIndex == 0
  //               ? _playStory(
  //                   storyContent: state.storyContent, shouldAnimate: false)
  //               : _playStory(
  //                   storyContent: state.storyContent, shouldAnimate: true);
  //         } else if (state.playState == PlayState.resume) {
  //           // _resumeStory(state.storyContent);
  //         }
  //       } else if (state is StoryContentPaused) {
  //         // _pauseStory(state.storyContent);
  //       }
  //     },
  //   ),
  // ],

  @override
  void dispose() {
    // _pageController.dispose();
    _animationController.dispose();
    _videoController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
