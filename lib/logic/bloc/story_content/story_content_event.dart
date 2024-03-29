part of 'story_content_bloc.dart';

abstract class StoryContentEvent extends Equatable {
  const StoryContentEvent();

  @override
  List<Object> get props => [];
}

//Events:
//LoadStoryContent
//PlayStoryContent
//PauseStoryContent
//ResumeStoryContent
//NextStoryContent
//PreviousStoryContent
//FinishStoryContent
//ResetStoryContent

class LoadStoryContent extends StoryContentEvent {
  final Story story;
  final int storyContentIndex;

  const LoadStoryContent(this.story, this.storyContentIndex);

  @override
  List<Object> get props => [story, storyContentIndex];
}

class PlayStoryContent extends StoryContentEvent {
  final Story story;
  final int storyContentIndex;

  const PlayStoryContent(this.story, this.storyContentIndex);

  @override
  List<Object> get props => [story, storyContentIndex];
}

class PauseStoryContent extends StoryContentEvent {
  final Story story;
  final int storyContentIndex;

  const PauseStoryContent(this.story, this.storyContentIndex);

  @override
  List<Object> get props => [story, storyContentIndex];
}

class ResumeStoryContent extends StoryContentEvent {
  final Story story;
  final int storyContentIndex;

  const ResumeStoryContent(this.story, this.storyContentIndex);

  @override
  List<Object> get props => [story, storyContentIndex];
}

class NextStoryContent extends StoryContentEvent {
  final Story story;
  final int storyContentIndex;

  const NextStoryContent(this.story, this.storyContentIndex);

  @override
  List<Object> get props => [story, storyContentIndex];
}

class PreviousStoryContent extends StoryContentEvent {
  final Story story;
  final int storyContentIndex;

  const PreviousStoryContent(this.story, this.storyContentIndex);

  @override
  List<Object> get props => [story, storyContentIndex];
}

class FinishStoryContent extends StoryContentEvent {
  final int storyContentIndex;
  const FinishStoryContent(this.storyContentIndex);

  @override
  List<Object> get props => [storyContentIndex];
}

class ResetStoryContent extends StoryContentEvent {
  const ResetStoryContent();

  @override
  List<Object> get props => [];
}
