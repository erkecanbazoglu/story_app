part of 'story_bloc.dart';

abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object> get props => [];
}

//States:
//InitialStory
//StoryOpened
//StoryClosed

class StoryInitial extends StoryState {
  const StoryInitial();

  @override
  List<Object> get props => [];
}

class StoryOpened extends StoryState {
  final Story story;
  final int storyIndex;
  const StoryOpened(this.story, this.storyIndex);

  @override
  List<Object> get props => [story, storyIndex];
}

class StoryClosed extends StoryState {
  final Story story;
  final int storyIndex;
  const StoryClosed(this.story, this.storyIndex);

  @override
  List<Object> get props => [story, storyIndex];
}
