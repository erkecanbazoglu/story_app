part of 'stories_bloc.dart';

abstract class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object> get props => [];
}

//States:
//StoriesLoading
//StoriesLoaded
//StoriesError
//StoriesInternetError

class StoriesLoading extends StoriesState {
  const StoriesLoading();

  @override
  List<Object> get props => [];
}

class StoriesLoaded extends StoriesState {
  final List<Story>? stories;
  const StoriesLoaded(this.stories);

  @override
  List<Object> get props => [stories!];
}

class StoriesError extends StoriesState {
  final String? message;
  const StoriesError(this.message);

  @override
  List<Object> get props => [message!];
}

class StoriesInternetError extends StoriesState {
  const StoriesInternetError();

  @override
  List<Object> get props => [];
}
