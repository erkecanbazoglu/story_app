import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'story_page.dart';
import '../widgets/story_widget.dart';
import '../../data/models/data.dart';
import '../../data/providers/photos.dart';
import 'others/first_page.dart';
import '../../data/models/story.dart';
import '../../data/repos/story_repo.dart';
import 'others/first_page.dart';
import '../widgets/photo_post_widget.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _customScrollViewController = ScrollController();
  final ScrollController _storyController = ScrollController();
  final key = GlobalKey();
  //Just a temp list with 10 items
  final List<int> _postList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<Story> stories = [];

  final StoryRepo _storyRepo = StoryRepo();

  // void testFunction() async {
  //   stories = await _storyRepo.prepareStoryContents();
  // }

  Future<List<Story>> generateStories() async {
    stories = await _storyRepo.prepareStoryContents();
    return Future.value(stories);
  }

  @override
  void initState() {
    super.initState();
    // testFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/codeway.png',
              // 'assets/avatars/1.jpg',
              height: 36,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              child: const Icon(
                Icons.add_circle_outline,
              ),
              onTap: () {
                //Like
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              child: const Icon(
                Icons.favorite_border_outlined,
              ),
              onTap: () {
                //Like
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              child: const Icon(
                Icons.sms_outlined,
              ),
              onTap: () {
                //Send
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _customScrollViewController,
        slivers: <Widget>[
          //Stories
          SliverToBoxAdapter(
            child: Column(
              children: [
                FutureBuilder<List<Story>>(
                  future: generateStories(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Story>> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      return SizedBox(
                        height: 70,
                        child: ListView.builder(
                          controller: _storyController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: stories.length,
                          itemBuilder: (context, index) {
                            return StoryWidget(
                              story: stories[index],
                              onStoryTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryPage2(
                                      stories: stories,
                                      storyIndex: index,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20,
                      );
                    } else {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          //Posts
          SliverList(
            key: key,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PhotoPost(photo: _postList[index]);
              },
              childCount: _postList.length,
            ),
          ),
        ],
      ),
    );
  }
}
