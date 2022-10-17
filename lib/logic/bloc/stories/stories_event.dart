part of 'stories_bloc.dart';

abstract class StoriesEvent extends Equatable {
  const StoriesEvent();

  @override
  List<Object> get props => [];
}

//Events:
//GetStories
//StoriesInternetNone

class GetStories extends StoriesEvent {
  const GetStories();

  @override
  List<Object> get props => [];
}

class StoriesInternetNone extends StoriesEvent {
  const StoriesInternetNone();

  @override
  List<Object> get props => [];
}
