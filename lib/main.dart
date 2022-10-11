import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/screens/welcome_page.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Story App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const WelcomePage(title: 'Flutter Story App'),
    );
  }
}
