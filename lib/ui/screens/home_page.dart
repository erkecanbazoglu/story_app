import 'package:flutter/material.dart';
import '../../data/providers/photos.dart';
import 'first_page.dart';
import '../widgets/photo_post_widget.dart';
import '../widgets/story_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //     _counter++;
  //   });
  // }
  ScrollController _scrollController = ScrollController();
  ScrollController _storyController = ScrollController();
  final key = GlobalKey();
  //Just a temp list with 10 items
  List<int> _postList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

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
              'images/codeway.png',
              // 'images/avatars/1.jpg',
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
                //Like
              },
            ),
          ),
        ],
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headline4,
      //       ),
      //     ],
      //   ),
      // ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              child: ListView.builder(
                controller: _storyController,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: _postList.length,
                itemBuilder: (context, index) {
                  return Story(photo: _postList[index]);
                },
              ),
            ),
          ),
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
      // body: Column(
      //   children: [
      //     PhotoPost(photo: 1),
      //     PhotoPost(photo: 4),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        // onPressed: () async {
        //   await _photosAPI.getPhotos();
        // },
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FirstPage()),
          );
        },
        heroTag: "floating-action-btn",
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
