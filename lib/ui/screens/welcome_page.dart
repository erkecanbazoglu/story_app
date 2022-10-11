import 'package:flutter/material.dart';
import 'package:test_app/ui/screens/others/fifth_page.dart';
import 'package:test_app/ui/screens/others/first_page.dart';
import 'package:test_app/ui/screens/others/fourth_page.dart';
import 'package:test_app/ui/screens/home_page.dart';
import 'package:test_app/ui/screens/others/second_page.dart';
import 'package:test_app/ui/screens/others/third_page.dart';
import '../../data/providers/photos.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      _counter++;
    });
  }

  final PhotosAPI _photosAPI = PhotosAPI();

  int _currentIndex = 0;
  final double iconSize = 24;
  final _homeTabs = [
    // FirstPage(),
    HomePage(),
    SecondPage(),
    ThirdPage(),
    FourthPage(),
    FifthPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
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
      body: IndexedStack(
        children: _homeTabs,
        index: _currentIndex,
      ),
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
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FittedBox(
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _onItemTapped(0);
                      });
                    },
                    child: Icon(
                      Icons.home,
                      color: _currentIndex == 0 ? Colors.amber : Colors.black38,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _onItemTapped(1);
                      });
                    },
                    child: Icon(
                      Icons.search,
                      color: _currentIndex == 1 ? Colors.amber : Colors.black38,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _onItemTapped(2);
                      });
                    },
                    child: Icon(
                      Icons.video_call,
                      color: _currentIndex == 2 ? Colors.amber : Colors.black38,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _onItemTapped(3);
                      });
                    },
                    child: Icon(
                      Icons.shopping_bag,
                      color: _currentIndex == 3 ? Colors.amber : Colors.black38,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      _onItemTapped(4);
                    },
                    child: Icon(
                      Icons.person,
                      color: _currentIndex == 4 ? Colors.amber : Colors.black38,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
