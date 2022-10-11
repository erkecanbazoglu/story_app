import 'package:flutter/material.dart';
import '../screens/story_page.dart';

class Story extends StatefulWidget {
  const Story({required this.photo});

  final int photo;

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  String? photo;

  @override
  void initState() {
    super.initState();
    photo = widget.photo.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StoryPage()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.amber,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFEDA77FF),
                Color(0x8134AFFF),
              ],
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(40.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/avatars/${photo}.jpg'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
