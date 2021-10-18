import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/users/users.dart';
import 'package:dio/dio.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial());

  final _usersRepository = UsersRepository();

  @override
  Stream<UsersState> mapEventToState(
    UsersEvent event,
  ) async* {
    if (event is GetUsers) {
      yield* _mapGetUsersDataState(event);
    }
    if (event is AddUser) {
      yield* _mapAddUsersDataState(event);
    }
  }

  Stream<UsersState> _mapGetUsersDataState(GetUsers event) async* {
    yield UsersDataLoading();
    try {
      Response _response = await _usersRepository.getUsers();
      if (_response.data["message"] != null) {
        final _usersResponse = UsersResponse.fromJson(_response.data);
        yield UsersDataLoaded(_usersResponse);
      } else {
        yield UsersLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield UsersLoadError(err.toString());
    }
  }

  Stream<UsersState> _mapAddUsersDataState(AddUser event) async* {
    yield UsersDataSending();
    try {
      Map<String, dynamic> user = {
        "name": event.name,
        "email": event.email,
        "password": event.password
      };
      Response _response = await _usersRepository.addUser(user);

      if (_response.data["message"] != null) {
        yield UsersDataSent(_response.data["message"]);
      } else {
        yield UsersDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield UsersDataSendError(err.toString());
    }
  }
}
