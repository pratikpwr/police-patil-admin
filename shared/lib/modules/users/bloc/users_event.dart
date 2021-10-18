part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class AddUser extends UsersEvent {
  final String name;
  final String email;
  final String password;

  const AddUser(
      {required this.name, required this.email, required this.password});

  @override
  List<Object?> get props => [name, email, password];
}

class GetUsers extends UsersEvent {}
