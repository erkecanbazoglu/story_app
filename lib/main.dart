import 'package:flutter/material.dart';
import 'package:test_app/ui/services/router_service.dart';
import 'ui/screens/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Story App',
      initialRoute: '/',
      navigatorKey: RouterService().navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const WelcomePage(title: 'Flutter Story App'),
    );
  }
}
