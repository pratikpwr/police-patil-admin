part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class AddPSUser extends UsersEvent {
  final String name;
  final String email;
  final String password;
  final String role;
  final String psId;

  const AddPSUser(
      {required this.name,
      required this.email,
      required this.password,
      required this.psId,
      required this.role});

  @override
  List<Object?> get props => [name, email, password, psId, role];
}

class EditPPUser extends UsersEvent {
  final int id;
  final String name;
  final String village;
  final String password;

  const EditPPUser(
      {required this.id,
      required this.name,
      required this.village,
      required this.password});

  @override
  List<Object?> get props => [name, id, village, password];
}

class AddPolicePatil extends UsersEvent {
  final String name;
  final String email;
  final String password;
  final String village;
  final String role;
  final String psId;

  const AddPolicePatil(
      {required this.name,
      required this.email,
      required this.password,
      required this.village,
      required this.psId,
      required this.role});

  @override
  List<Object?> get props => [name, email, password, village, psId, role];
}

class GetPPUsers extends UsersEvent {}

class GetPSUsers extends UsersEvent {}
