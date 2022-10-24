import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/story.dart';

class StoryAvatar extends StatelessWidget {
  final Story story;
  final VoidCallback onStoryTap;

  const StoryAvatar({
    Key? key,
    required this.story,
    required this.onStoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStoryTap,
      child: CachedNetworkImage(
        imageUrl: story.user.profileImage,
        imageBuilder: (context, imageProvider) => Container(
          width: 70,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.amber,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: story.storySeen
                    ? [
                        Colors.grey.shade200,
                        Colors.grey.shade400,
                      ]
                    : [
                        Color(0xFEDA77FF),
                        Color(0x8134AFFF),
                      ],
              ),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Hero(
                    //Hero for the specified user tag
                    tag: story.id,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
