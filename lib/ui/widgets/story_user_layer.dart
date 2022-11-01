import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../data/models/story.dart';
import '../../logic/bloc/story/story_bloc.dart';
import '../../logic/bloc/story_content/story_content_bloc.dart';
import 'animated_bar.dart';
import 'dart:math' as math;

class StoryUserLayer extends StatelessWidget {
  final AnimationController animationController;
  final AnimationController tempAnimationController;
  final List<Story> stories;
  final VoidCallback closePage;
  final int carouselIndex;
  final int nextAnimationIndex;
  final int previousAnimationIndex;
  // final int currentIndex;

  const StoryUserLayer({
    Key? key,
    required this.animationController,
    required this.tempAnimationController,
    required this.stories,
    required this.closePage,
    required this.carouselIndex,
    required this.nextAnimationIndex,
    required this.previousAnimationIndex,
    // required this.currentIndex,
  }) : super(key: key);

  // AnimationController(vsync: this)

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, storyState) {
          if (storyState is StoryOpened) {
            return BlocBuilder<StoryContentBloc, StoryContentState>(
              builder: (context, storyContentState) {
                if (storyContentState is StoryContentPlayed) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Row(
                          children: stories[carouselIndex]
                              .userStories
                              .asMap()
                              .map((index, storyItem) {
                                return MapEntry(
                                  index,
                                  AnimatedBar(
                                    animationController:
                                        storyState.storyIndex == carouselIndex
                                            ? animationController
                                            : tempAnimationController,
                                    position: index,
                                    currentIndex: carouselIndex ==
                                            storyState.storyIndex + 1
                                        ? nextAnimationIndex
                                        : carouselIndex ==
                                                storyState.storyIndex - 1
                                            ? previousAnimationIndex
                                            : storyContentState
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: stories[carouselIndex]
                                        .user
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
                                            style: const TextStyle(
                                                color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: stories[carouselIndex]
                                                    .user
                                                    .name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: (storyState.storyIndex ==
                                                        carouselIndex
                                                    //     &&
                                                    // storyContentState
                                                    //     is StoryContentPlayed
                                                    )
                                                    ? '  ${storyState.story.userStories[storyContentState.storyContentIndex].sentTimestamp.toString()}h'
                                                    : '  ${stories[carouselIndex].userStories[0].sentTimestamp.toString()}h',
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
                                            onPressed: closePage,
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
                  );
                } else if (storyContentState is StoryContentLoading) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Row(
                          children: stories[carouselIndex]
                              .userStories
                              .asMap()
                              .map((index, storyItem) {
                                return MapEntry(
                                  index,
                                  AnimatedBar(
                                    animationController:
                                        storyState.storyIndex == carouselIndex
                                            ? animationController
                                            : tempAnimationController,
                                    position: index,
                                    currentIndex: storyState.storyIndex ==
                                            carouselIndex
                                        ? storyContentState.storyContentIndex
                                        : 0,
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
                                    imageUrl: stories[carouselIndex]
                                        .user
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
                                            style: const TextStyle(
                                                color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: stories[carouselIndex]
                                                    .user
                                                    .name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: storyState.storyIndex ==
                                                        carouselIndex
                                                    ? '  ${storyState.story.userStories[storyContentState.storyContentIndex].sentTimestamp.toString()}h'
                                                    : '  ${stories[carouselIndex].userStories[0].sentTimestamp.toString()}h',
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
                                            onPressed: closePage,
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
                  );
                }
                return const SizedBox.shrink();
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
