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
    if (event is GetPPUsers) {
      yield* _mapGetPPUsersDataState(event);
    }
    if (event is EditPPUser) {
      yield* _mapEditPPUsersDataState(event);
    }
    if (event is GetPSUsers) {
      yield* _mapGetPSUsersDataState(event);
    }
    if (event is AddPSUser) {
      yield* _mapAddPSUsersDataState(event);
    }
    if (event is AddPolicePatil) {
      yield* _mapAddPolicePatilDataState(event);
    }
  }

  Stream<UsersState> _mapGetPPUsersDataState(GetPPUsers event) async* {
    yield UsersDataLoading();
    try {
      Response _response = await _usersRepository.getPPUsers();
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

  Stream<UsersState> _mapEditPPUsersDataState(EditPPUser event) async* {
    yield UsersDataLoading();
    try {
      Map<String, dynamic> _body = {
        "name": event.name,
        "password": event.password
      };
      Response _response =
          await _usersRepository.updateUserData(event.id, _body);
      if (_response.data["message"] != null) {
        yield UserDataUpdated(_response.data["message"]);
      } else {
        yield UsersLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield UsersLoadError(err.toString());
    }
  }

  Stream<UsersState> _mapGetPSUsersDataState(GetPSUsers event) async* {
    yield UsersDataLoading();
    try {
      Response _response = await _usersRepository.getPSUsers();
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

  Stream<UsersState> _mapAddPSUsersDataState(AddPSUser event) async* {
    yield UsersDataSending();
    try {
      Map<String, dynamic> user = {
        "name": event.name,
        "email": event.email,
        "password": event.password,
        "role": event.role,
        "psid": event.psId
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

  Stream<UsersState> _mapAddPolicePatilDataState(AddPolicePatil event) async* {
    yield UsersDataSending();
    try {
      Map<String, dynamic> user = {
        "name": event.name,
        "email": event.email,
        "password": event.password,
        "role": event.role,
        "village": event.village,
        "psid": event.psId
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
