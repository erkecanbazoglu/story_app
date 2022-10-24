import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../data/models/story.dart';
import '../../../data/repos/stories_repo.dart';

part 'stories_event.dart';
part 'stories_state.dart';

///Stories Bloc:

class StoriesBloc extends HydratedBloc<StoriesEvent, StoriesState> {
  final StoriesRepo? storiesRepo;
  StoriesBloc(this.storiesRepo) : super(const StoriesLoading()) {
    // super.hydrate();
    on<GetStories>(_onGetStories);
    on<UpdateStories>(_onUpdateStories);
    on<StoriesInternetNone>(_onStoriesInternetNone);
    on<MakeStoriesSeen>(_onMakeStoriesSeen);
  }

  ///Get Stories Event

  Future<void> _onGetStories(
      GetStories event, Emitter<StoriesState> emit) async {
    emit(const StoriesLoading());
    try {
      final stories = await storiesRepo?.getFinalStories();
      emit(StoriesLoaded(stories!));
    } catch (e) {
      emit(const StoriesError("Error loading the stories!"));
    }
  }

  ///Update Stories Event

  Future<void> _onUpdateStories(
      UpdateStories event, Emitter<StoriesState> emit) async {
    emit(const StoriesLoading());

    final stories = _updateStories(event.stories);

    emit(StoriesLoaded(stories));
  }

  ///Make Stories Seen Event

  Future<void> _onMakeStoriesSeen(
      MakeStoriesSeen event, Emitter<StoriesState> emit) async {
    List<Story> stories = event.stories;

    int storyIndex = event.storyIndex;
    int storyContentIndex = event.storyContentIndex;

    ///Change to false to make Story Content unseen again
    stories[storyIndex].userStories[storyContentIndex].contentSeen = true;

    ///Change to false to make Story unseen again
    if (storyContentIndex == stories[storyIndex].userStories.length - 1) {
      stories[storyIndex].storySeen = true;
    }
    Stories storiesObject = Stories(
      stories: stories,
    );
    emit(StoriesLoaded(storiesObject));
  }

  ///Internet Gone Event

  Future<void> _onStoriesInternetNone(
      StoriesInternetNone event, Emitter<StoriesState> emit) async {
    emit(const StoriesInternetError());
  }

  Stories _updateStories(stories) {
    List<Story> seen = [];
    List<Story> unSeen = [];

    for (int i = 0; i < stories.length; i++) {
      bool isStorySeen = true;
      for (int k = 0; k < stories[i].userStories.length; k++) {
        if (stories[i].userStories[k].contentSeen == false) {
          isStorySeen = false;
          break;
        }
      }

      if (isStorySeen) {
        seen.add(stories[i]);
      } else {
        unSeen.add(stories[i]);
      }
    }

    List<Story> newStories = List.from(unSeen)..addAll(seen);
    Stories storyObject = Stories(
      stories: newStories,
    );

    return storyObject;
  }

  @override
  StoriesState? fromJson(Map<String, dynamic> json) {
    try {
      final stories = Stories.fromJson(json);
      //To make stories null
      // final stories = null;
      if (stories == null) {
        print("stories: null");
      } else {
        final updatedStories = _updateStories(stories.stories);
        return StoriesLoaded(updatedStories);
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(dynamic state) {
    if (state is StoriesLoaded) {
      return state.stories.toJson();
    } else {
      return null;
    }
  }
}
