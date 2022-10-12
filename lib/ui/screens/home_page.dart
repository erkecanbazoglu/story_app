import 'package:flutter/material.dart';
import 'package:test_app/ui/screens/story_page2.dart';
import '../../data/models/data.dart';
import '../../data/providers/photos.dart';
import 'others/first_page.dart';
import '../widgets/photo_post_widget.dart';
import '../widgets/story_widget.dart';

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

  final PhotosAPI _photosAPI = PhotosAPI();

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
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                controller: _storyController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _postList.length,
                itemBuilder: (context, index) {
                  return storyAvatars(photo: _postList[index]);
                },
              ),
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

class storyAvatars extends StatelessWidget {
  final int photo;

  const storyAvatars({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryPage2(
                      stories: stories,
                    )),
          );
        },
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
            borderRadius: BorderRadius.all(
              Radius.circular(40.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Hero(
                  tag: photo,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/avatars/${photo}.jpg'),
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
