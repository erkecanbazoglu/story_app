import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/story.dart';
import '../screens/story_page.dart';
import '../../../data/models/data.dart';
import '../screens/story_page2.dart';

class StoryWidget extends StatelessWidget {
  final Story story;

  const StoryWidget({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoryPage2(
                    story: story,
                  )),
        );
      },
      child: CachedNetworkImage(
        imageUrl: story.user.profileImage,
        imageBuilder: (context, imageProvider) => Container(
          width: 70,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Container(
            decoration: const BoxDecoration(
              // color: Colors.amber,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
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
