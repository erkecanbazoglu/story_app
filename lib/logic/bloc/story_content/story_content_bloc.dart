import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/story.dart';
import '../../../data/repos/story_content_repo.dart';
import '../../../services/shared_preferences.dart';

part 'story_content_event.dart';
part 'story_content_state.dart';

class StoryContentBloc extends Bloc<StoryContentEvent, StoryContentState> {
  final StoryContentRepo? storyContentRepo;
  StoryContentBloc(this.storyContentRepo) : super(const StoryClosedInitial()) {
    on<PlayStoryContent>(_onPlayStoryContent);
    on<PauseStoryContent>(_onPauseStoryContent);
    on<ResumeStoryContent>(_onResumeStoryContent);
    on<NextStoryContent>(_onNextStoryContent);
    on<PreviousStoryContent>(_onPreviousStoryContent);
  }

  ///Bloc events

  Future<void> _onPlayStoryContent(
      PlayStoryContent event, Emitter<StoryContentState> emit) async {
    print("Play state: " + state.toString());
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.begin));
    print("Play state: " + state.toString());
  }

  Future<void> _onPauseStoryContent(
      PauseStoryContent event, Emitter<StoryContentState> emit) async {
    print("Pause state: " + state.toString());
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.paused));
    print("Pause state: " + state.toString());
  }

  Future<void> _onResumeStoryContent(
      ResumeStoryContent event, Emitter<StoryContentState> emit) async {
    print("Resume state: " + state.toString());
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.resume));
    print("Resume state: " + state.toString());
  }

  Future<void> _onNextStoryContent(
      NextStoryContent event, Emitter<StoryContentState> emit) async {
    print("Next state: " + state.toString());
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.begin));
    print("Next state: " + state.toString());
  }

  Future<void> _onPreviousStoryContent(
      PreviousStoryContent event, Emitter<StoryContentState> emit) async {
    print("Previous state: " + state.toString());
    emit(StoryContentPlayed(event.story.userStories[event.storyContentIndex],
        event.storyContentIndex, PlayState.begin));
    print("Previous state: " + state.toString());
  }
}
