import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_app/data/repos/stories_repo.dart';
import 'package:test_app/logic/bloc/stories_bloc.dart';
import 'package:test_app/services/shared_preferences.dart';
import 'logic/cubit/internet_cubit.dart';
import 'ui/services/router_service.dart';
import 'logic/bloc/user_bloc.dart';
import 'ui/screens/welcome_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    SharedPreferencesService.init()
  ]);
  runApp(
    MyApp(connectivity: Connectivity()),
  );
}

class MyApp extends StatelessWidget {
  final Connectivity connectivity;
  const MyApp({
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
        BlocProvider<StoriesBloc>(
          // read: context.read<InternetCubit>(),
          create: (context) => StoriesBloc(StoriesRepo()),
        ),
        // BlocProvider<UserBloc>(
        //   create: (context) => UserBloc(),
        // ),
      ],
      child: MaterialApp(
        title: 'Story App',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        navigatorKey: RouterService().navigatorKey,
        supportedLocales: const [
          Locale('tr', ''), // Turkish, no country code
          Locale('en', ''), // English, no country code
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const WelcomePage(title: 'Flutter Story App'),
      ),
    );
  }
}
