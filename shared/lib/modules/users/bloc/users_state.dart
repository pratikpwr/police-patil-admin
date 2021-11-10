part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {}

class UsersDataLoading extends UsersState {}

class UserDataUpdated extends UsersState {
  final String message;

  const UserDataUpdated(this.message);
}

class UsersDataLoaded extends UsersState {
  final UsersResponse userResponse;

  const UsersDataLoaded(this.userResponse);

  @override
  List<Object> get props => [userResponse];
}

class UsersLoadError extends UsersState {
  final String message;

  const UsersLoadError(this.message);
}

class UsersDataSending extends UsersState {}

class UsersDataSent extends UsersState {
  final String message;

  const UsersDataSent(this.message);
}

class UsersDataSendError extends UsersState {
  final String error;

  const UsersDataSendError(this.error);
}
