import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/story.dart';
import '../../../data/repos/story_repo.dart';

part 'story_event.dart';
part 'story_state.dart';

///Story Bloc:

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepo? storyRepo;
  StoryBloc(this.storyRepo) : super(const StoryInitial()) {
    on<OpenStory>(_onOpenStory);
    on<CloseStory>(_onCloseStory);
    on<NextStory>(_onNextStory);
    on<PreviousStory>(_onPreviousStory);
  }

  ///Open Story Event

  Future<void> _onOpenStory(OpenStory event, Emitter<StoryState> emit) async {
    emit(StoryOpened(event.stories[event.storyIndex], event.storyIndex));
    print("Open event: " + state.toString());
  }

  ///CLose Story Event

  Future<void> _onCloseStory(CloseStory event, Emitter<StoryState> emit) async {
    emit(StoryClosed(event.stories[event.storyIndex], event.storyIndex));
    print("Close event: " + state.toString());
  }

  ///Next Story Event

  Future<void> _onNextStory(NextStory event, Emitter<StoryState> emit) async {
    emit(StoryOpened(event.stories[event.storyIndex], event.storyIndex));
    print("Next event: " + state.toString());
  }

  ///Previous Story Event

  Future<void> _onPreviousStory(
      PreviousStory event, Emitter<StoryState> emit) async {
    emit(StoryOpened(event.stories[event.storyIndex], event.storyIndex));
    print("Previous event: " + state.toString());
  }
}
