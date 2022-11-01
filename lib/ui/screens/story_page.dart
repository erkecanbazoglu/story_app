import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
// import './carousel/carousel_slider.dart';
import '../../logic/bloc/stories/stories_bloc.dart';
import '../../logic/bloc/story/story_bloc.dart';
import '../../services/cache_manager.dart';
import '../../logic/bloc/story_content/story_content_bloc.dart';
import '../../services/shared_preferences.dart';
import '../widgets/story_progress_indicator.dart';
import '../widgets/story_user_layer.dart';
import '../widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import '../../data/models/story.dart';

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
    with TickerProviderStateMixin, WidgetsBindingObserver {
  ///Controllers
  late PageController _pageController;
  late PageController _previousPageController;
  late PageController _nextPageController;
  late VideoPlayerController _videoController;
  late VideoPlayerController _previousVideoController;
  late VideoPlayerController _nextVideoController;
  late AnimationController _animationController;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final GlobalKey _carouselKey = GlobalKey();

  ///Bloc
  late final storyBloc;
  late final storyContentBloc;
  late final storiesBloc;

  ///Others variables
  late dynamic imageFile;
  late List<Story> stories;
  List storyPlayIndexes = [];
  bool isPageChanging = false;
  int previousAnimationBarIndex = 0;
  int nextAnimationBarIndex = 0;
  double? screenWidth;
  double? dx;

  ///Init - Reset the controllers
  void _initControllers() {
    var storyState = storyBloc.state;
    _pageController =
        PageController(initialPage: storyPlayIndexes[storyState.storyIndex]);
    _nextPageController = PageController(initialPage: 0);
    _previousPageController = PageController(initialPage: 0);
    _animationController = AnimationController(vsync: this);

    String initialVideoUrl =
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

    for (int i = 0; i < stories[widget.storyIndex].userStories.length; i++) {
      if (stories[widget.storyIndex].userStories[i].media == MediaType.video) {
        initialVideoUrl = stories[widget.storyIndex].userStories[i].url;
        break;
      }
    }

    _videoController = VideoPlayerController.network(initialVideoUrl);
    _videoController.initialize();
    _previousVideoController = VideoPlayerController.network(initialVideoUrl);
    _previousVideoController.initialize();
    _nextVideoController = VideoPlayerController.network(initialVideoUrl);
    _nextVideoController.initialize();
  }

  void _resetControllers() {
    var storyState = storyBloc.state;

    ///Swiping to the Next Page
    if (storyState.storyIndex >= 0 &&
        storyState.storyIndex < stories.length - 1) {
      //Animated Bar
      nextAnimationBarIndex = storyPlayIndexes[storyState.storyIndex + 1];
      //Page Controller
      _nextPageController = PageController(
          initialPage: storyPlayIndexes[storyState.storyIndex + 1]);
      //Video Player
      final storyContent =
          stories[storyState.storyIndex + 1].userStories[nextAnimationBarIndex];
      if (storyContent.media == MediaType.video) {
        _nextVideoController = VideoPlayerController.network(storyContent.url);
        _nextVideoController.initialize();
      }
    }

    ///Swiping to the Previous Page
    if (storyState.storyIndex > 0 && storyState.storyIndex < stories.length) {
      //Animated Bar
      previousAnimationBarIndex = storyPlayIndexes[storyState.storyIndex - 1];
      //Page Controller
      _previousPageController = PageController(
          initialPage: storyPlayIndexes[storyState.storyIndex - 1]);
      //Video Player
      final storyContent = stories[storyState.storyIndex - 1]
          .userStories[previousAnimationBarIndex];
      if (storyContent.media == MediaType.video) {
        _previousVideoController =
            VideoPlayerController.network(storyContent.url);
        _previousVideoController.initialize();
      }
    }
  }

  ///Background caching for faster loading
  void _backgroundCaching() async {
    for (int i = 0; i < stories.length; i++) {
      ///If Story seen, pass (no need)
      if (stories[i].storySeen) continue;

      for (int k = 0; k < stories[i].userStories.length; k++) {
        ///If Story Content seen, pass (no need)
        if (stories[i].userStories[k].contentSeen) continue;

        final storyContent = stories[i].userStories[k];
        switch (storyContent.media) {
          case MediaType.image:
            final fileInfo =
                await CacheManagerService.checkCacheFor(storyContent.url);
            if (fileInfo == null) {
              CacheManagerService.cachedForUrl(storyContent.url);
            }
            break;
          case MediaType.video:
            final fileInfo =
                await CacheManagerService.checkCacheFor(storyContent.url);
            if (fileInfo == null) {
              CacheManagerService.cachedForUrl(storyContent.url);
            }
            break;
          default:
            break;
        }
      }
    }
  }

  ///Getting images with Future Builder
  Future<File> _getImages(storyIndex, storyContentIndex) async {
    final storyContent = stories[storyIndex].userStories[storyContentIndex];
    final fileInfo = await CacheManagerService.checkCacheFor(storyContent.url);
    if (fileInfo == null) {
      await CacheManagerService.cachedForUrl(storyContent.url);
      final fileInfo =
          await CacheManagerService.checkCacheFor(storyContent.url);
      imageFile = fileInfo?.file;
    } else {
      imageFile = fileInfo.file;
    }
    if (storyContentBloc.state.playState == PlayState.begin) {
      _playStoryContentEvent();
    }
    return imageFile;
  }

  ///Play - Pause - Resume - Load the Story Content

  void _playStory(StoryContent storyContent) async {
    _animationController.stop();
    _animationController.reset();

    var storyState = storyBloc.state;
    var storyContentState = storyContentBloc.state;
    var storiesState = storiesBloc.state;

    //Story Seen with Shared Preferences (Deprecated)
    // SharedPreferencesService.setStoryContentSeen(storyContent!.id);
    // storyContent.contentSeen = true;

    //Story Seen with Hydrated Storage
    storiesBloc.add(MakeStoriesSeen(storiesState.stories.stories,
        storyState.storyIndex, storyContentState.storyContentIndex));

    ///Updating Story Play Index
    storyPlayIndexes[storyState.storyIndex] =
        storyContentState.storyContentIndex;

    switch (storyContent.media) {
      case MediaType.image:
        _animationController.duration = storyContent.duration;
        _animationController.forward();
        break;
      case MediaType.video:
        setState(() {
          if (_videoController.value.isInitialized) {
            _animationController.duration = _videoController.value.duration;
            _videoController.play();
            _animationController.forward();
          }
        });
        break;
      default:
        _loadStoryContent();
        break;
    }
  }

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

  void _loadStoryContent() async {
    var storyContentState = storyContentBloc.state;
    final storyContent = storyContentState.storyContent;

    _animationController.stop();

    ///Caching checked and implemented during the loading state
    switch (storyContent.media) {
      case MediaType.image:
        // Image caching moved to Future Builder
        break;
      case MediaType.video:
        final fileInfo =
            await CacheManagerService.checkCacheFor(storyContent.url);
        if (fileInfo == null) {
          _videoController = VideoPlayerController.network(storyContent.url);
          await CacheManagerService.cachedForUrl(storyContent.url);
          await _videoController.initialize();
        } else {
          final file = fileInfo.file;
          _videoController = VideoPlayerController.file(file);
          await _videoController.initialize();
        }
        break;
      default:
        break;
    }

    ///Here latency can be tested
    await Future.delayed(const Duration(milliseconds: 0), () {});
    _playStoryContentEvent();
  }

  ///StoryBloc Events

  void _openStoryEvent(int storyIndex) {
    storyBloc.add(OpenStory(stories, storyIndex));
  }

  void _closeStoryEvent() {
    var storyState = storyBloc.state;
    storyBloc.add(CloseStory(stories, storyState.storyIndex));
  }

  void _nextStoryEvent() {
    var storyState = storyBloc.state;
    storyBloc.add(NextStory(stories, storyState.storyIndex));
  }

  void _previousStoryEvent() {
    var storyState = storyBloc.state;
    storyBloc.add(PreviousStory(stories, storyState.storyIndex));
  }

  ///StoryContentBloc Events

  void _loadStoryContentEvent() {
    var storyState = storyBloc.state;
    _resetControllers();

    ///This method is only called on new Story
    int firstStoryContent = storyPlayIndexes[storyState.storyIndex];
    storyContentBloc.add(LoadStoryContent(storyState.story, firstStoryContent));
  }

  void _playStoryContentEvent() {
    var storyState = storyBloc.state;
    var storyContentState = storyContentBloc.state;
    storyContentBloc.add(PlayStoryContent(
        storyState.story, storyContentState.storyContentIndex));
  }

  void _pauseStoryContentEvent() {
    var storyContentState = storyContentBloc.state;
    var storyState = storyBloc.state;
    storyContentBloc.add(PauseStoryContent(
        storyState.story, storyContentState.storyContentIndex));
  }

  void _resumeStoryContentEvent() {
    var storyContentState = storyContentBloc.state;
    var storyState = storyBloc.state;
    storyContentBloc.add(ResumeStoryContent(
        storyState.story, storyContentState.storyContentIndex));
  }

  void _nextStoryContentEvent() {
    _animationController.stop();
    _animationController.reset();
    _videoController.pause();

    var storyContentState = storyContentBloc.state;
    var storyState = storyBloc.state;
    storyContentBloc.add(NextStoryContent(
        storyState.story, storyContentState.storyContentIndex));
  }

  void _previousStoryContentEvent() {
    _animationController.stop();
    _animationController.reset();
    _videoController.pause();

    var storyContentState = storyContentBloc.state;
    var storyState = storyBloc.state;
    storyContentBloc.add(PreviousStoryContent(
        storyState.story, storyContentState.storyContentIndex));
  }

  @override
  void initState() {
    super.initState();
    storyBloc = BlocProvider.of<StoryBloc>(context);
    storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
    storiesBloc = BlocProvider.of<StoriesBloc>(context);

    stories = widget.stories;

    for (int i = 0; i < stories.length; i++) {
      storyPlayIndexes.add(stories[i].storyPlayIndex);
    }

    ///For getting the app lifecycle
    WidgetsBinding.instance?.addObserver(this);

    ///Initializing controllers
    _initControllers();

    ///Background image and video caching
    _backgroundCaching();

    ///Playing the first Story Content
    _loadStoryContentEvent();

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
    } else if (state == AppLifecycleState.resumed) {
      _resumeStoryContentEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StoryBloc, StoryState>(
          listener: (context, state) async {
            if (state is StoryOpened) {
              if (state.openState == OpenState.playCurrent) {
                _loadStoryContentEvent();
              } else if (state.openState == OpenState.playNext) {
                setState(() {
                  _carouselController.nextPage();
                });
              } else if (state.openState == OpenState.playPrev) {
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
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  _pageController.jumpToPage(state.storyContentIndex);
                });
                _playStory(state.storyContent);
              } else if (state.playState == PlayState.resume) {
                _resumeStoryContent(state.storyContent);
              } else if (state.playState == PlayState.paused) {
                _pauseStoryContent(state.storyContent);
              } else if (state.playState == PlayState.loading) {
                _loadStoryContent();
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
            return WillPopScope(
              onWillPop: () async => false,
              child: AbsorbPointer(
                absorbing: isPageChanging,
                child: DismissiblePage(
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
                      itemCount: stories.length,
                      unlimitedMode: false,
                      slideTransform: const CubeTransform(),
                      autoSliderTransitionCurve: Curves.easeInOut,
                      autoSliderTransitionTime:
                          const Duration(milliseconds: 300),
                      // onSlideChanged: (index) => _moveToNewStory(index),
                      onSlideStart: (_) {
                        isPageChanging = true;
                        _pauseStoryContentEvent();
                      },
                      onSlideEnd: (newStoryIndex) {
                        var storyState = storyBloc.state;

                        ///Carousel Page Changed
                        if (storyState.storyIndex != newStoryIndex) {
                          _animationController.stop();
                          _animationController.reset();

                          _openStoryEvent(newStoryIndex);
                        } else {
                          _resumeStoryContentEvent();
                        }
                        isPageChanging = false;
                      },
                      slideBuilder: (carouselIndex) {
                        return BlocBuilder<StoryContentBloc, StoryContentState>(
                          builder: (context, storyContentState) {
                            if (storyContentState is StoryContentPlayed) {
                              return Stack(
                                children: [
                                  GestureDetector(
                                    //get the very first tap event
                                    onTapDown: (details) {
                                      screenWidth =
                                          MediaQuery.of(context).size.width;
                                      dx = details.globalPosition.dx;
                                      _pauseStoryContentEvent();
                                    },
                                    //validate tap event
                                    onTap: () {
                                      if (dx! < screenWidth! / 3) {
                                        _previousStoryContentEvent();
                                      } else {
                                        _nextStoryContentEvent();
                                      }
                                    },
                                    //resume the story
                                    onLongPressEnd: (_) =>
                                        _resumeStoryContentEvent(),
                                    child: Hero(
                                        tag: stories[carouselIndex].id,
                                        child: PageView.builder(
                                          controller: carouselIndex ==
                                                  storyState.storyIndex + 1
                                              ? _nextPageController
                                              : carouselIndex ==
                                                      storyState.storyIndex - 1
                                                  ? _previousPageController
                                                  : _pageController,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: stories[carouselIndex]
                                              .userStories
                                              .length,
                                          itemBuilder: (context, storyIndex) {
                                            // final storyContent = storyState
                                            //     .story.userStories[storyIndex];
                                            final storyContent =
                                                stories[carouselIndex]
                                                    .userStories[storyIndex];
                                            switch (storyContent.media) {
                                              case MediaType.image:
                                                return FutureBuilder<File>(
                                                  future: _getImages(
                                                      carouselIndex,
                                                      storyIndex), // a previously-obtained Future<String> or null
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<File>
                                                              snapshot) {
                                                    Widget child;
                                                    if (snapshot.hasData) {
                                                      child = Image(
                                                        image: FileImage(
                                                            snapshot.data!),
                                                        fit: BoxFit.cover,
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      child = const Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                        size: 45,
                                                      );
                                                    } else {
                                                      child =
                                                          const StoryProgressIndicator();
                                                    }
                                                    return child;
                                                  },
                                                );
                                              case MediaType.video:
                                                if (_videoController
                                                    .value.isInitialized) {
                                                  return VideoPlayerWidget(
                                                      controller: carouselIndex ==
                                                              storyState
                                                                      .storyIndex +
                                                                  1
                                                          ? _nextVideoController
                                                          : carouselIndex ==
                                                                  storyState
                                                                          .storyIndex -
                                                                      1
                                                              ? _previousVideoController
                                                              : _videoController);
                                                }
                                                break;
                                            }

                                            return const StoryProgressIndicator();
                                          },
                                        )),
                                  ),
                                  storyContentState.playState ==
                                          PlayState.loading
                                      ? const StoryProgressIndicator()
                                      : const SizedBox.shrink(),
                                  StoryUserLayer(
                                    animationController: _animationController,
                                    tempAnimationController:
                                        AnimationController(vsync: this),
                                    stories: stories,
                                    closePage: _closeStoryEvent,
                                    carouselIndex: carouselIndex,
                                    nextAnimationIndex: nextAnimationBarIndex,
                                    previousAnimationIndex:
                                        previousAnimationBarIndex,
                                  ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
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
