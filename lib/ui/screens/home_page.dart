import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/logic/cubit/internet_cubit.dart';
import '../../logic/bloc/stories_bloc.dart';
import 'story_page.dart';
import '../widgets/story_widget.dart';
import '../../data/models/story.dart';
import '../widgets/photo_post_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _customScrollViewController = ScrollController();
  final ScrollController _storyController = ScrollController();
  final key = GlobalKey();
  //Just a temp list with 10 items
  final List<int> _postList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  late List<Story> stories;

  void getStories() {
    // Always provide context for bloc in order to update the UI
    final storiesBloc = BlocProvider.of<StoriesBloc>(context);
    storiesBloc.add(const GetStories());
  }

  double getScrollIndex(int storyIndex) {
    double screenWidth = MediaQuery.of(context).size.width;
    double rightOffset = (screenWidth / 70).floorToDouble();
    double maxScroll = (stories.length * 70) - rightOffset;

    if (storyIndex == 0) {
      return 0;
    } else if (storyIndex > 0 && ((storyIndex - 1) * 70) < maxScroll) {
      return (storyIndex - 1) * 70;
    } else {
      return maxScroll;
    }
  }

  @override
  void initState() {
    super.initState();
    getStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/codeway.png',
              // 'assets/avatars/1.jpg',
              height: 36,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              child: const Icon(
                Icons.add_circle_outline,
              ),
              onTap: () {
                //Like
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              child: const Icon(
                Icons.favorite_border_outlined,
              ),
              onTap: () {
                //Like
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              child: const Icon(
                Icons.sms_outlined,
              ),
              onTap: () {
                //Send
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        cacheExtent: 3500,
        shrinkWrap: false,
        physics: const BouncingScrollPhysics(),
        controller: _customScrollViewController,
        slivers: <Widget>[
          //Stories
          SliverToBoxAdapter(
            child: BlocConsumer<StoriesBloc, StoriesState>(
              listener: (context, state) {
                if (state is StoriesError) {
                  final internetCubit = BlocProvider.of<InternetCubit>(context);
                  String snackbarText =
                      internetCubit.state is InternetDisconnected
                          ? "Internet error!"
                          : state.message!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(snackbarText),
                    ),
                  );
                }

                //     if (state is StoriesLoaded) {
                //   context.read<ThemeCubit>().updateTheme(state.weather);
                // }
              },
              builder: (context, state) {
                if (state is StoriesLoading) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                    ],
                  );
                } else if (state is StoriesError) {
                  if (BlocProvider.of<InternetCubit>(context).state
                      is InternetDisconnected) {
                    return const Text("Internet error!");
                  } else {
                    return Text(state.message!);
                  }
                } else if (state is StoriesLoaded) {
                  stories = state.stories!;
                  return SizedBox(
                    height: 70,
                    child: ListView.builder(
                      controller: _storyController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        return StoryWidget(
                          story: stories[index],
                          onStoryTap: () async {
                            int storyIndex = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryPage2(
                                  stories: stories,
                                  storyIndex: index,
                                ),
                              ),
                            );
                            _storyController.jumpTo(getScrollIndex(storyIndex));
                          },
                        );
                      },
                    ),
                  );
                }
                return const Text('Something went wrong!');
              },
            ),
          ),

          //Posts
          SliverList(
            key: key,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PhotoPost(post: _postList[index]);
              },
              childCount: _postList.length,
            ),
          ),
        ],
      ),
    );
  }
}
