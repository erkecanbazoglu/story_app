import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/data.dart';
import '../../data/models/user.dart';

part '../bloc/user_state.dart';

enum UserEvent {
  restricted,
  unrestricted,
  loading,
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState.loading(User.empty));

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    switch (event) {
      case UserEvent.loading:
        emitUserLoading(user);
        break;
      case UserEvent.restricted:
        emitUserRestricted(user);
        break;
      case UserEvent.unrestricted:
        emitUserUnrestricted(user);
        break;
    }
  }

  ///State changed to Loading on app launch
  void emitUserLoading(User user) => emit(UserState.loading(user));

  ///User Loaded the Stories
  void emitUserRestricted(User user) {
    ///Analytics action can be handled here
    emit(UserState.restricted(user));
  }

  void emitUserUnrestricted(User user) => emit(UserState.unrestricted(user));
}
