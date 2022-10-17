part of 'story_bloc.dart';

abstract class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object> get props => [];
}

//Events:
//OpenStory
//CloseStory
//NextStory
//PreviousStory

class OpenStory extends StoryEvent {
  final List<Story> stories;
  final int storyIndex;

  const OpenStory(this.stories, this.storyIndex);

  @override
  List<Object> get props => [stories, storyIndex];
}

class CloseStory extends StoryEvent {
  final List<Story> stories;
  final int storyIndex;

  const CloseStory(this.stories, this.storyIndex);

  @override
  List<Object> get props => [stories, storyIndex];
}

class NextStory extends StoryEvent {
  final List<Story> stories;
  final int storyIndex;

  const NextStory(this.stories, this.storyIndex);

  @override
  List<Object> get props => [stories, storyIndex];
}

class PreviousStory extends StoryEvent {
  final List<Story> stories;
  final int storyIndex;

  const PreviousStory(this.stories, this.storyIndex);

  @override
  List<Object> get props => [stories, storyIndex];
}
