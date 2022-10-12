part of '../bloc/user_bloc.dart';

class UserState {
  final User user;
  const UserState._({
    this.user = User.empty,
  });

  @override
  List<Object> get props => [user];

  const UserState.loading(User user) : this._(user: user);

  const UserState.restricted(User user) : this._(user: user);

  const UserState.unrestricted(User user) : this._(user: user);
}

// ///User State is Loading
// class UserLoading extends UserState {}
//
// ///User is Restricted and will be unseen in Stories
// class UserRestricted extends UserState {}
//
// ///User is Unrestricted, just a friend
// class UserUnrestricted extends UserState {}
