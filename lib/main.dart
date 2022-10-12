import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/logic/bloc/internet_bloc.dart';
import 'package:test_app/ui/services/router_service.dart';
import 'ui/screens/welcome_page.dart';

void main() {
  runApp(MyApp(
    connectivity: Connectivity(),
  ));
}

class MyApp extends StatelessWidget {
  final Connectivity connectivity;
  MyApp({
    Key? key,
    required this.connectivity,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
          create: (context) => InternetCubit(connectivity: connectivity),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Story App',
        initialRoute: '/',
        navigatorKey: RouterService().navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const WelcomePage(title: 'Flutter Story App'),
      ),
    );
  }
}
