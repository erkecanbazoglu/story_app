part of 'stories_bloc.dart';

abstract class StoriesEvent extends Equatable {
  const StoriesEvent();

  @override
  List<Object> get props => [];
}

//Events:
//GetStories
//UpdateStories
//MakeStoriesSeen
//StoriesInternetNone

class GetStories extends StoriesEvent {
  const GetStories();

  @override
  List<Object> get props => [];
}

class UpdateStories extends StoriesEvent {
  final List<Story> stories;
  const UpdateStories(this.stories);

  @override
  List<Object> get props => [stories];
}

class MakeStoriesSeen extends StoriesEvent {
  final List<Story> stories;
  final int storyIndex;
  final int storyContentIndex;
  const MakeStoriesSeen(this.stories, this.storyIndex, this.storyContentIndex);

  @override
  List<Object> get props => [stories, storyIndex, storyContentIndex];
}

class StoriesInternetNone extends StoriesEvent {
  const StoriesInternetNone();

  @override
  List<Object> get props => [];
}
