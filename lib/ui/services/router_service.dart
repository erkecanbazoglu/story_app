import 'package:flutter/material.dart';
import '../screens/others/fifth_page.dart';
import '../screens/others/first_page.dart';
import '../screens/others/fourth_page.dart';
import '../screens/home_page.dart';
import '../screens/others/second_page.dart';
import '../screens/others/third_page.dart';

class RouterService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(Pages routeName, {dynamic data}) {
    switch (routeName) {
      case Pages.homePage:
        return navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => HomePage(),
            settings: RouteSettings(
                name: Pages.homePage.toString(), arguments: data)));
      case Pages.firstPage:
        return navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => FirstPage(),
            settings: RouteSettings(
                name: Pages.firstPage.toString(), arguments: data)));
      case Pages.secondPage:
        return navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => SecondPage(),
            settings: RouteSettings(
                name: Pages.secondPage.toString(), arguments: data)));
      case Pages.thirdPage:
        return navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => ThirdPage(),
            settings: RouteSettings(
                name: Pages.thirdPage.toString(), arguments: data)));
      case Pages.fourthPage:
        return navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => FourthPage(),
            settings: RouteSettings(
                name: Pages.fourthPage.toString(), arguments: data)));
      case Pages.fifthPage:
        return navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => FifthPage(),
            settings: RouteSettings(
                name: Pages.fifthPage.toString(), arguments: data)));
    }
  }
}

enum Pages {
  homePage,
  firstPage,
  secondPage,
  thirdPage,
  fourthPage,
  fifthPage,
}
