import 'package:flutter/material.dart';
import './ui/screens/home_page.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const HomePage(title: 'Flutter Story App'),
    );
  }
}
