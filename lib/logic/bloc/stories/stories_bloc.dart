import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/story.dart';
import '../../../data/repos/stories_repo.dart';

part 'stories_event.dart';
part 'stories_state.dart';

///Stories Bloc:

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final StoriesRepo? storiesRepo;
  StoriesBloc(this.storiesRepo) : super(const StoriesLoading()) {
    on<GetStories>(_onGetStories);
    on<StoriesInternetNone>(_onStoriesInternetNone);
  }

  ///Get Stories Event

  Future<void> _onGetStories(
      GetStories event, Emitter<StoriesState> emit) async {
    emit(const StoriesLoading());
    try {
      final stories = await storiesRepo?.getFinalStories();
      emit(StoriesLoaded(stories));
    } catch (e) {
      emit(const StoriesError("Error loading the stories!"));
    }
  }

  ///Internet Gone Event

  Future<void> _onStoriesInternetNone(
      StoriesInternetNone event, Emitter<StoriesState> emit) async {
    emit(const StoriesInternetError());
  }

  //Previous bloc event implementation

  // on<StoriesEvent>((event, emit) async {
  //   if (event is GetStories) {
  //     emit(const StoriesLoading());
  //     try {
  //       final stories = await storiesRepo?.getFinalStories();
  //       emit(StoriesLoaded(stories));
  //       print("here completed");
  //     } catch (e) {
  //       emit(const StoriesError("Error loading the stories!"));
  //     }
  //   }
  // });

}
