import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'data/repos/stories_repo.dart';
import 'data/repos/story_content_repo.dart';
import 'data/repos/story_repo.dart';
import 'logic/bloc/stories/stories_bloc.dart';
import 'logic/bloc/story/story_bloc.dart';
import 'logic/bloc/story_content/story_content_bloc.dart';
import 'logic/cubit/internet_cubit.dart';
import 'services/navigator_service.dart';
import 'services/shared_preferences.dart';
import 'ui/screens/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());

  ///Device orientation and Shared Preferences initialization
  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    SharedPreferencesService.init()
  ]);

  HydratedBlocOverrides.runZoned(
    () {
      runApp(MyApp(connectivity: Connectivity()));
    },
    storage: storage,
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
          create: (context) => StoriesBloc(StoriesRepo()),
        ),
        BlocProvider<StoryBloc>(
          create: (context) => StoryBloc(StoryRepo()),
        ),
        BlocProvider<StoryContentBloc>(
          create: (context) => StoryContentBloc(StoryContentRepo()),
        ),
        // BlocProvider<UserBloc>(
        //   create: (context) => UserBloc(),
        // ),
      ],
      child: MaterialApp(
        title: 'Story App',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigatorService().navigatorKey,
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
