import 'package:flutter/material.dart';

import '../../services/navigator_service.dart';
import 'home_page.dart';
import 'others/fifth_page.dart';
import 'others/fourth_page.dart';
import 'others/second_page.dart';
import 'others/third_page.dart';

///The First Page that handles the navigation
///Includes Bottom Navigation Bar Widget
///
///Includes Navigations to below pages:
///Test Pages: First, Second, Third, Fourth, Fifth Page
///Main Page: Home Page

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  ///Bottom Navbar index
  int _currentIndex = 0;

  final double iconSize = 24;

  ///Bottom Navbar Pages
  final _homeTabs = [
    const HomePage(),
    SecondPage(),
    ThirdPage(),
    FourthPage(),
    FifthPage(),
  ];

  ///Changes the Bottom Navbar Page
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
          NavigatorService().navigateTo(Pages.firstPage);
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
              bottomNavbarWidget(_currentIndex, 0, Icons.home),
              bottomNavbarWidget(_currentIndex, 1, Icons.search),
              bottomNavbarWidget(_currentIndex, 2, Icons.video_call),
              bottomNavbarWidget(_currentIndex, 3, Icons.shopping_bag),
              bottomNavbarWidget(_currentIndex, 4, Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  ///Bottom Navbar Widgets
  Widget bottomNavbarWidget(_currentIndex, index, icon) {
    return Expanded(
      flex: 1,
      child: FittedBox(
        child: MaterialButton(
          minWidth: 40,
          onPressed: () {
            setState(() {
              _onItemTapped(index);
            });
          },
          child: Icon(
            icon,
            color: _currentIndex == index ? Colors.amber : Colors.black38,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
