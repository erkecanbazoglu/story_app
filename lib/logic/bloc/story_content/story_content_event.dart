part of 'story_content_bloc.dart';

abstract class StoryContentEvent extends Equatable {
  const StoryContentEvent();

  @override
  List<Object> get props => [];
}

//Events:
//PlayStoryContent
//PauseStoryContent
//ResumeStoryContent
//NextStoryContent
//PreviousStoryContent

class PlayStoryContent extends StoryContentEvent {
  final Story story;
  final int storyContentIndex;
  final PlayState playState;

  const PlayStoryContent(this.story, this.storyContentIndex, this.playState);

  @override
  List<Object> get props => [story, storyContentIndex, playState];
}

class PauseStoryContent extends StoryContentEvent {
  final Story story;
  final int storyContentIndex;
  final PlayState playState;

  const PauseStoryContent(this.story, this.storyContentIndex, this.playState);

  @override
  List<Object> get props => [story, storyContentIndex, playState];
}

class ResumeStoryContent extends StoryContentEvent {
  final Story story;
  final int storyContentIndex;
  final PlayState playState;

  const ResumeStoryContent(this.story, this.storyContentIndex, this.playState);

  @override
  List<Object> get props => [story, storyContentIndex, playState];
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
