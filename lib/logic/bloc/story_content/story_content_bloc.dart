import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/story.dart';
import '../../../data/repos/story_content_repo.dart';

part 'story_content_event.dart';
part 'story_content_state.dart';

///Story Content Bloc:

class StoryContentBloc extends Bloc<StoryContentEvent, StoryContentState> {
  final StoryContentRepo? storyContentRepo;
  StoryContentBloc(this.storyContentRepo) : super(const StoryContentInitial()) {
    on<LoadStoryContent>(_onLoadStoryContent);
    on<PlayStoryContent>(_onPlayStoryContent);
    on<PauseStoryContent>(_onPauseStoryContent);
    on<ResumeStoryContent>(_onResumeStoryContent);
    on<NextStoryContent>(_onNextStoryContent);
    on<PreviousStoryContent>(_onPreviousStoryContent);
    on<FinishStoryContent>(_onFinishStoryContent);
    on<ResetStoryContent>(_onResetStoryContent);
  }

  ///Load Story Content Event

  Future<void> _onLoadStoryContent(
      LoadStoryContent event, Emitter<StoryContentState> emit) async {
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.loading));
    // print("Load Story Content event: " + state.toString());
  }

  ///Play Story Content Event

  Future<void> _onPlayStoryContent(
      PlayStoryContent event, Emitter<StoryContentState> emit) async {
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.begin));
    // print("Play Story Content event: " + state.toString());
  }

  ///Pause Story Content Event

  Future<void> _onPauseStoryContent(
      PauseStoryContent event, Emitter<StoryContentState> emit) async {
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.paused));
    // print("Pause Story Content event: " + state.toString());
  }

  ///Resume Story Content Event

  Future<void> _onResumeStoryContent(
      ResumeStoryContent event, Emitter<StoryContentState> emit) async {
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.resume));
    // print("Resume Story Content event: " + state.toString());
  }

  ///Next Story Content Event

  Future<void> _onNextStoryContent(
      NextStoryContent event, Emitter<StoryContentState> emit) async {
    if (event.storyContentIndex < event.story.userStories.length - 1) {
      int storyContentIndex = event.storyContentIndex + 1;
      emit(StoryContentPlayed(event.story.userStories[storyContentIndex],
          storyContentIndex, PlayState.loading));
      // emit(StoryContentPlayed(event.story.userStories[storyContentIndex],
      //     storyContentIndex, PlayState.begin));
    } else {
      emit(StoryContentFinished(event.storyContentIndex, PlayState.next));
      // emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
      //     event.storyContentIndex, PlayState.next));
    }
    // print("Next Story Content event: " + state.toString());
  }

  ///Previous Story Content Event

  Future<void> _onPreviousStoryContent(
      PreviousStoryContent event, Emitter<StoryContentState> emit) async {
    if (event.storyContentIndex > 0) {
      int storyContentIndex = event.storyContentIndex - 1;
      emit(StoryContentPlayed(event.story.userStories[storyContentIndex],
          storyContentIndex, PlayState.loading));
      // emit(StoryContentPlayed(event.story.userStories[storyContentIndex],
      //     storyContentIndex, PlayState.begin));
    } else {
      emit(StoryContentFinished(event.storyContentIndex, PlayState.prev));
      // emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
      //     event.storyContentIndex, PlayState.prev));
    }
    // print("Previous Story Content event: " + state.toString());
  }

  ///Finish Story Content Event

  Future<void> _onFinishStoryContent(
      FinishStoryContent event, Emitter<StoryContentState> emit) async {
    emit(StoryContentFinished(event.storyContentIndex, PlayState.none));
    // print("Finish Story Content event: " + state.toString());
  }

  ///Reset Story Content Event

  Future<void> _onResetStoryContent(
      ResetStoryContent event, Emitter<StoryContentState> emit) async {
    emit(const StoryContentInitial());
    // print("Reset Story Content event: " + state.toString());
  }
}
