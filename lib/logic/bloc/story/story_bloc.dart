import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/story.dart';
import '../../../data/repos/story_repo.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepo? storyRepo;
  StoryBloc(this.storyRepo) : super(const StoryInitial()) {
    on<OpenStory>(_onOpenStory);
    on<CloseStory>(_onCloseStory);
    on<NextStory>(_onNextStory);
    on<PreviousStory>(_onPreviousStory);
  }

  ///Bloc events

  Future<void> _onOpenStory(OpenStory event, Emitter<StoryState> emit) async {
    print("Open state: " + state.toString());
    emit(StoryOpened(event.stories[event.storyIndex], event.storyIndex));
    print("Open state: " + state.toString());
  }

  Future<void> _onCloseStory(CloseStory event, Emitter<StoryState> emit) async {
    print("Close state: " + state.toString());
    emit(StoryClosed(event.stories[event.storyIndex], event.storyIndex));
    print("Close state: " + state.toString());
  }

  Future<void> _onNextStory(NextStory event, Emitter<StoryState> emit) async {
    print("Next state: " + state.toString());
    emit(StoryOpened(event.stories[event.storyIndex], event.storyIndex));
    print("Next state: " + state.toString());
  }

  Future<void> _onPreviousStory(
      PreviousStory event, Emitter<StoryState> emit) async {
    print("Previous state: " + state.toString());
    emit(StoryOpened(event.stories[event.storyIndex], event.storyIndex));
    print("Previous state: " + state.toString());
  }
}
