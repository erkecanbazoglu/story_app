import 'package:flutter/material.dart';
import 'others/fifth_page.dart';
import 'others/first_page.dart';
import 'others/fourth_page.dart';
import 'home_page.dart';
import 'others/second_page.dart';
import 'others/third_page.dart';
import '../../data/providers/photos.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PhotosAPI _photosAPI = PhotosAPI();

  int _currentIndex = 0;
  final double iconSize = 24;
  final _homeTabs = [
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
      body: IndexedStack(
        children: _homeTabs,
        index: _currentIndex,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FirstPage(),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
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
