part of 'story_content_bloc.dart';

enum PlayState {
  begin,
  paused,
  resume,
  loading,
  next,
  prev,
  none,
}

abstract class StoryContentState extends Equatable {
  const StoryContentState();

  @override
  List<Object> get props => [];
}

//States:
//StoryContentInitial
//StoryContentLoading
//StoryContentPlayed
//StoryContentError

class StoryContentInitial extends StoryContentState {
  const StoryContentInitial();

  @override
  List<Object> get props => [];
}

class StoryContentLoading extends StoryContentState {
  final StoryContent storyContent;
  final int storyContentIndex;
  const StoryContentLoading(this.storyContent, this.storyContentIndex);

  @override
  List<Object> get props => [storyContent, storyContentIndex];
}

class StoryContentPlayed extends StoryContentState {
  final StoryContent storyContent;
  final int storyContentIndex;
  final PlayState playState;
  const StoryContentPlayed(
      this.storyContent, this.storyContentIndex, this.playState);

  @override
  List<Object> get props => [storyContent, storyContentIndex, playState];
}

class StoryContentFinished extends StoryContentState {
  final int storyContentIndex;
  final PlayState playState;
  const StoryContentFinished(this.storyContentIndex, this.playState);

  @override
  List<Object> get props => [storyContentIndex, playState];
}

class StoryContentError extends StoryContentState {
  final String? message;
  const StoryContentError(this.message);

  @override
  List<Object> get props => [message!];
}
