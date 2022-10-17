part of 'story_content_bloc.dart';

enum PlayState {
  begin,
  paused,
  resume,
  next,
  prev,
}

abstract class StoryContentState extends Equatable {
  const StoryContentState();

  @override
  List<Object> get props => [];
}

//States:
//InitialStoryClosed
//StoryContentPlayed
//StoryContentError

class StoryClosedInitial extends StoryContentState {
  const StoryClosedInitial();

  @override
  List<Object> get props => [];
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

class StoryContentError extends StoryContentState {
  final String? message;
  const StoryContentError(this.message);

  @override
  List<Object> get props => [message!];
}
