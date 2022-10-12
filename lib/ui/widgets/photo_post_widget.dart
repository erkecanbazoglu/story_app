import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhotoPost extends StatefulWidget {
  const PhotoPost({required this.photo});

  final int photo;

  @override
  State<PhotoPost> createState() => _PhotoPostState();
}

class _PhotoPostState extends State<PhotoPost> {
  int random(int min, int max) {
    return min + math.Random().nextInt(max - min);
  }

  String? photo;

  @override
  void initState() {
    super.initState();
    photo = widget.photo.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Profile picture, username and location
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/avatars/${photo}.jpg'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      // AppLocalizations.of(context)!.helloWorld,
                      "Erke Canbazoğlu",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Longoz Ormanları",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    child: const Icon(Icons.more_horiz_outlined),
                    onTap: () {
                      //Add to bookmarks
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        //The image post
        SizedBox(
          // height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          child: Image.asset(
            'assets/posts/${photo}.jpg',
            fit: BoxFit.cover,
          ),
        ),
        //The rest (icons, likes, comments)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: const Icon(
                        Icons.favorite_border,
                      ),
                      onTap: () {
                        //Like
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      child: const Icon(Icons.mode_comment_outlined),
                      onTap: () {
                        //Comment
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Transform.rotate(
                      angle: -math.pi / 7,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: InkWell(
                          child: const Icon(
                            Icons.send_outlined,
                          ),
                          onTap: () {
                            //Send the post
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          child: const Icon(Icons.bookmark_border),
                          onTap: () {
                            //Add to bookmarks
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('${random(20, 350)} likes')),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: RichText(
                  text: const TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "User name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "  " +
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus molestie mauris ultrices neque rhoncus maximus.",
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "View all ${random(2, 20)} comments",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
