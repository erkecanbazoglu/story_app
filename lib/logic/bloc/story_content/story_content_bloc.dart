import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/story.dart';
import '../../../data/repos/story_content_repo.dart';

part 'story_content_event.dart';
part 'story_content_state.dart';

///Story Content Bloc:

class StoryContentBloc extends Bloc<StoryContentEvent, StoryContentState> {
  final StoryContentRepo? storyContentRepo;
  StoryContentBloc(this.storyContentRepo) : super(const StoryClosedInitial()) {
    on<PlayStoryContent>(_onPlayStoryContent);
    on<PauseStoryContent>(_onPauseStoryContent);
    on<ResumeStoryContent>(_onResumeStoryContent);
    on<NextStoryContent>(_onNextStoryContent);
    on<PreviousStoryContent>(_onPreviousStoryContent);
  }

  ///Play Story Content Event

  Future<void> _onPlayStoryContent(
      PlayStoryContent event, Emitter<StoryContentState> emit) async {
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.begin));
    print("Play event: " + state.toString());
  }

  ///Pause Story Content Event

  Future<void> _onPauseStoryContent(
      PauseStoryContent event, Emitter<StoryContentState> emit) async {
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.paused));
    print("Pause event: " + state.toString());
  }

  ///Resume Story Content Event

  Future<void> _onResumeStoryContent(
      ResumeStoryContent event, Emitter<StoryContentState> emit) async {
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.resume));
    print("Resume event: " + state.toString());
  }

  ///Next Story Content Event

  Future<void> _onNextStoryContent(
      NextStoryContent event, Emitter<StoryContentState> emit) async {
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.begin));
    print("Next event: " + state.toString());
  }

  ///Previous Story Content Event

  Future<void> _onPreviousStoryContent(
      PreviousStoryContent event, Emitter<StoryContentState> emit) async {
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.begin));
    print("Previous event: " + state.toString());
  }
}
