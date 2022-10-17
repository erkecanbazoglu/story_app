part of '../cubit/internet_cubit.dart';

enum ConnectionType {
  Wifi,
  Mobile,
}

@immutable
abstract class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object> get props => [];
}

//States:
//InternetLoading
//InternetConnected
//InternetDisconnected

class InternetLoading extends InternetState {
  const InternetLoading();

  @override
  List<Object> get props => [];
}

class InternetConnected extends InternetState {
  final ConnectionType connectionType;

  const InternetConnected({required this.connectionType});

  @override
  List<Object> get props => [connectionType];
}

class InternetDisconnected extends InternetState {
  const InternetDisconnected();

  @override
  List<Object> get props => [];
}
