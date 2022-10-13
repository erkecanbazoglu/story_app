import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'stories_state.dart';

enum StoriesEvent {
  initialLoad,
  userLoad,
  loaded,
}

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  StoriesBloc() : super(StoriesLoading());

  @override
  Stream<StoriesState> mapEventToState(StoriesEvent event) async* {
    switch (event) {
      case StoriesEvent.initialLoad:
        emitStoriesInitialLoading();
        break;
      case StoriesEvent.userLoad:
        emitStoriesUserLoading();
        break;
      case StoriesEvent.loaded:
        emitStoriesLoaded();
        break;
    }
  }

  ///State changed to Loading on app launch
  void emitStoriesInitialLoading() => emit(StoriesLoading());

  ///User Loaded the Stories
  void emitStoriesUserLoading() {
    ///Analytics action can be handled here
    emit(StoriesLoading());
  }

  ///Stories are loaded
  void emitStoriesLoaded() => emit(StoriesLoaded());
}
