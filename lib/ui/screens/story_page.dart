import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_carousel_slider/carousel_slider.dart';
import './carousel/carousel_slider.dart';
import 'package:test_app/logic/bloc/story/story_bloc.dart';
import '../../logic/bloc/story_content/story_content_bloc.dart';
import '../../services/shared_preferences.dart';
import '../widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math' as math;
import 'dart:async';
import '../../data/models/story.dart';
import '../widgets/animated_bar.dart';

// export 'package:video_player_platform_interface/video_player_platform_interface.dart'
//     show DurationRange, DataSourceType, VideoFormat, VideoPlayerOptions;
// export 'src/closed_caption_file.dart';

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
  ///Controllers
  late PageController _pageController;
  late VideoPlayerController _videoController;
  late AnimationController _animationController;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final GlobalKey _carouselKey = GlobalKey();

  ///Bloc
  late final storyBloc;
  late final storyContentBloc;

  // Others variables
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
  void _playStory(StoryContent? storyContent) async {
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
  }

  ///Initializing the video controller
  ///If not problem occurs on dispose
  void initVideoController() {
    // if (story.userStories[_currentIndex].media == MediaType.video) {
    //   _videoController =
    //       VideoPlayerController.network(story.userStories[_currentIndex].url)
    //         ..initialize().then((_) {
    //           setState(() {});
    //         });
    // } else {
    _videoController = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4")
      ..initialize().then((_) {
        setState(() {});
      });
    // }
  }

  ///Gets the first unseen Story Content
  // void getInitialUnseenIndex() {
  //   for (int i = 0; i < story.userStories.length; i++) {
  //     if (story.userStories[i].contentSeen == false) {
  //       _currentIndex = i;
  //       break;
  //     }
  //   }
  // }

  ///Move to new story after carousel page slide
  void _moveToNewStory(int newStoryIndex) {
    var storyState = storyBloc.state;

    if (storyState is StoryOpened) {
      _openStoryEvent(widget.stories, newStoryIndex);
    }
  }

  ///Gesture Function: Initial tap move
  void _onTapDown(TapDownDetails details) {
    screenWidth = MediaQuery.of(context).size.width;
    dx = details.globalPosition.dx;
    _pauseStoryContentEvent();
  }

  ///Gesture Function: Tap confirmed
  void _onTap() async {
    _resumeStoryContentEvent();

    if (dx! < screenWidth! / 3) {
      _previousStoryContentEvent();
    } else {
      _nextStoryContentEvent();
    }
  }

  ///Pause - Resume the Story Content

  void _pauseStoryContent(storyContent) {
    if (storyContent.media == MediaType.video) {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _animationController.stop();
      }
    } else {
      _animationController.stop();
    }
  }

  void _resumeStoryContent(storyContent) {
    if (storyContent.media == MediaType.video) {
      _videoController.play();
      _animationController.forward();
    } else {
      _animationController.forward();
    }
  }

  ///StoryBloc Events

  void _openStoryEvent(List<Story> stories, int storyIndex) {
    storyBloc.add(OpenStory(stories, storyIndex));
  }

  void _closeStoryEvent() {
    var storyState = storyBloc.state;

    if (storyState is StoryOpened) {
      storyBloc.add(CloseStory(widget.stories, storyState.storyIndex));
    }
  }

  void _nextStoryEvent() {
    var storyState = storyBloc.state;

    if (storyState is StoryOpened) {
      storyBloc.add(NextStory(widget.stories, storyState.storyIndex));
    }
  }

  void _previousStoryEvent() {
    var storyState = storyBloc.state;

    if (storyState is StoryOpened) {
      storyBloc.add(PreviousStory(widget.stories, storyState.storyIndex));
    }
  }

  ///StoryContentBloc Events

  void _playStoryContentEvent() {
    var storyState = storyBloc.state;

    if (storyState is StoryOpened) {
      ///Change later
      int tempCurrentIndex = 0;
      storyContentBloc
          .add(PlayStoryContent(storyState.story, tempCurrentIndex));
    }
  }

  void _pauseStoryContentEvent() {
    var storyContentState = storyContentBloc.state;
    var storyState = storyBloc.state;

    if (storyState is StoryOpened && storyContentState is StoryContentPlayed) {
      final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
      storyContentBloc.add(PauseStoryContent(
          storyState.story, storyContentState.storyContentIndex));
    }
  }

  void _resumeStoryContentEvent() {
    var storyContentState = storyContentBloc.state;
    var storyState = storyBloc.state;

    if (storyState is StoryOpened && storyContentState is StoryContentPlayed) {
      final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
      storyContentBloc.add(ResumeStoryContent(
          storyState.story, storyContentState.storyContentIndex));
    }
  }

  void _nextStoryContentEvent() {
    var storyContentState = storyContentBloc.state;
    var storyState = storyBloc.state;

    if (storyState is StoryOpened && storyContentState is StoryContentPlayed) {
      final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
      storyContentBloc.add(NextStoryContent(
          storyState.story, storyContentState.storyContentIndex));
    }
  }

  void _previousStoryContentEvent() {
    var storyContentState = storyContentBloc.state;
    var storyState = storyBloc.state;

    if (storyState is StoryOpened && storyContentState is StoryContentPlayed) {
      final storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
      storyContentBloc.add(PreviousStoryContent(
          storyState.story, storyContentState.storyContentIndex));
    }
  }

  @override
  void initState() {
    super.initState();
    storyBloc = BlocProvider.of<StoryBloc>(context);
    storyContentBloc = BlocProvider.of<StoryContentBloc>(context);

    ///For getting the app lifecycle
    WidgetsBinding.instance?.addObserver(this);

    ///Getting the first unseen story content
    // getInitialUnseenIndex();

    ///Controller initialization
    // _pageController = PageController(initialPage: 0);
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);

    ///Video controller initialized
    initVideoController();

    // _openStoryEvent(widget.stories, widget.storyIndex);
    final StoryContent initialStory =
        widget.stories[widget.storyIndex].userStories[0];
    _playStory(initialStory);

    ///Animation Controller listener (for auto page slides)
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStoryContentEvent();
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
      _pauseStoryContentEvent();
      // _pauseStory(story.userStories[_currentIndex]);
    } else if (state == AppLifecycleState.resumed) {
      _resumeStoryContentEvent();
      // _resumeStory(story.userStories[_currentIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StoryBloc, StoryState>(
          listener: (context, state) {
            if (state is StoryOpened) {
              if (state.openState == OpenState.playCurrent) {
                _playStoryContentEvent();
              } else if (state.openState == OpenState.playNext) {
                _playStoryContentEvent();
                setState(() {
                  _carouselController.nextPage();
                });
              } else if (state.openState == OpenState.playPrev) {
                _playStoryContentEvent();
                setState(() {
                  _carouselController.previousPage();
                });
              } else if (state.openState == OpenState.closed) {
                Navigator.pop(context, state.storyIndex);
              }
            }
          },
        ),
        BlocListener<StoryContentBloc, StoryContentState>(
          listener: (context, state) {
            if (state is StoryContentPlayed) {
              if (state.playState == PlayState.begin) {
                ///Change should animate on first and laters
                _pageController.animateToPage(state.storyContentIndex,
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.easeInOut);
                _playStory(state.storyContent);
              } else if (state.playState == PlayState.resume) {
                _resumeStoryContent(state.storyContent);
              } else if (state.playState == PlayState.paused) {
                _pauseStoryContent(state.storyContent);
              }

              ///StoryContent Finished state
            } else if (state is StoryContentFinished) {
              if (state.playState == PlayState.next) {
                _nextStoryEvent();
              } else if (state.playState == PlayState.prev) {
                _previousStoryEvent();
              }
            }
          },
        ),
      ],
      child: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, storyState) {
          if (storyState is StoryOpened) {
            return BlocBuilder<StoryContentBloc, StoryContentState>(
              builder: (context, storyContentState) {
                if (storyContentState is StoryContentPlayed) {
                  return DismissiblePage(
                    onDismissed: () {
                      _closeStoryEvent();
                    },
                    onDragStart: () => _pauseStoryContentEvent(),
                    onDragEnd: () => _resumeStoryContentEvent(),
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
                        autoSliderTransitionTime:
                            const Duration(milliseconds: 300),
                        // onSlideChanged: (index) => _moveToNewStory(index),
                        // onSlideStart: () => _pauseStoryContentEvent(),
                        // onSlideEnd: () => _resumeStoryContentEvent(),
                        slideBuilder: (carouselIndex) {
                          return Stack(
                            children: [
                              GestureDetector(
                                //get the very first tap event
                                onTapDown: (details) => _onTapDown(details),
                                //validate tap event
                                onTap: () => _onTap(),
                                //resume the story
                                onLongPressEnd: (_) =>
                                    _resumeStoryContentEvent(),
                                child: Hero(
                                    tag: widget.stories[carouselIndex].id,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          storyState.story.userStories.length,
                                      itemBuilder: (context, storyIndex) {
                                        final storyContent = widget
                                            .stories[carouselIndex]
                                            .userStories[storyIndex];
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
                                        children: storyState.story.userStories
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
                                                  imageUrl: widget
                                                      .stories[carouselIndex]
                                                      .user
                                                      .profileImage,
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
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                          children: [
                                                            TextSpan(
                                                              text: widget
                                                                  .stories[
                                                                      carouselIndex]
                                                                  .user
                                                                  .name,
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
                                                                  '  ${widget.stories[carouselIndex].userStories[storyContentState.storyContentIndex].sentTimestamp.toString()}h',
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
                                                            _closeStoryEvent();
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
                                                Expanded(
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
                                                              const OutlineInputBorder(
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
                                                          hintStyle:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                          ),
                                                          hintText:
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .sendMessage,
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
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _videoController.dispose();
    _carouselController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
