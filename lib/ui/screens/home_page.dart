import 'package:flutter/material.dart';
import '../../data/providers/photos.dart';
import 'first_page.dart';
import '../widgets/photo_post_widget.dart';

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
        title: Row(
          children: [
            Text("Codeway"),
          ],
        ),
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
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
