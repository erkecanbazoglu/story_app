import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/story_content/story_content_bloc.dart';
import '../../logic/cubit/internet_cubit.dart';
import '../../services/navigator_service.dart';
import '../../logic/bloc/stories/stories_bloc.dart';
import '../../logic/bloc/story/story_bloc.dart';
import '../widgets/story_avatar.dart';
import '../../data/models/story.dart';
import '../widgets/photo_post_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///Controller
  final ScrollController _customScrollViewController = ScrollController();
  final ScrollController _storyController = ScrollController();
  final key = GlobalKey();

  ///Bloc
  late final storyBloc;
  late final storyContentBloc;

  ///Others variables
  final List<int> _postList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  late List<Story> stories;

  ///Getting the scroll index for sliding to the correct story avatar
  double getScrollIndex(int storyIndex) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxAvatar = (screenWidth / 70).floorToDouble();
    double rightOffset = maxAvatar * 70;
    double maxScroll =
        ((stories.length - (maxAvatar + 1)) * 70) + (screenWidth - rightOffset);

    if (storyIndex == 0) {
      return 0;
    } else if (storyIndex > 0 && ((storyIndex - 1) * 70) < maxScroll) {
      return (storyIndex - 1) * 70;
    } else {
      return maxScroll;
    }
  }

  void _getStories() {
    // Always provide context for bloc in order to update the UI
    final storiesBloc = BlocProvider.of<StoriesBloc>(context);
    storiesBloc.add(const GetStories());
  }

  ///Opens the related bloc content
  void openStory(int storyIndex) {
    storyBloc.add(OpenStory(stories, storyIndex));
  }

  ///Resets the Story Content state
  void _resetStoryContentEvent() {
    storyContentBloc.add(const ResetStoryContent());
  }

  @override
  void initState() {
    super.initState();
    storyBloc = BlocProvider.of<StoryBloc>(context);
    storyContentBloc = BlocProvider.of<StoryContentBloc>(context);
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
            child: BlocListener<StoryBloc, StoryState>(
              listener: (context, state) {
                if (state is StoryOpened) {
                  // _resetStoryContentEvent();
                }
              },
              child: BlocConsumer<StoriesBloc, StoriesState>(
                listener: (context, state) {
                  if (state is StoriesError) {
                    final internetCubit =
                        BlocProvider.of<InternetCubit>(context);
                    String snackbarText =
                        internetCubit.state is InternetDisconnected
                            ? AppLocalizations.of(context)!.internetError
                            : state.message!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(snackbarText),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is StoriesLoading) {
                    _getStories();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                      ],
                    );
                  } else if (state is StoriesError) {
                    if (BlocProvider.of<InternetCubit>(context).state
                        is InternetDisconnected) {
                      return Text(AppLocalizations.of(context)!.internetError);
                    } else {
                      return Text(state.message!);
                    }
                  } else if (state is StoriesLoaded) {
                    stories = state.stories.stories;
                    // stories = state.stories!;
                    return SizedBox(
                      height: 70,
                      child: ListView.builder(
                        controller: _storyController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: stories.length,
                        itemBuilder: (context, index) {
                          return StoryAvatar(
                            story: stories[index],
                            onStoryTap: () async {
                              openStory(index);
                              int storyIndex = await NavigatorService()
                                  .navigateTo(Pages.storyPage, data: {
                                'stories': stories,
                                'storyIndex': index
                              });
                              _resetStoryContentEvent();
                              _storyController
                                  .jumpTo(getScrollIndex(storyIndex));
                            },
                          );
                        },
                      ),
                    );
                  }
                  return Text(AppLocalizations.of(context)!.somethingWentWrong);
                },
              ),
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
