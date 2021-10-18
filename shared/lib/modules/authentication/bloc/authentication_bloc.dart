import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:shared/modules/authentication/models/user.dart';
import 'package:shared/modules/authentication/resources/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());
  final AuthenticationRepository authenticationService =
      AuthenticationRepository();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (event is AppLoadedUp) {
      yield* _mapAppSignUpLoadedState(event);
    }

    if (event is UserLogin) {
      yield* _mapUserLoginState(event);
    }
    if (event is UserLogOut) {
      sharedPreferences.setString('authToken', '');
      sharedPreferences.setInt('userId', 0);
      yield UserLogoutState();
    }
  }

  Stream<AuthenticationState> _mapAppSignUpLoadedState(
      AppLoadedUp event) async* {
    yield AuthenticationLoading();
    try {
      // a simulated delay for splash
      await Future.delayed(const Duration(seconds: 1));
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? authToken = sharedPreferences.getString('authToken');
      if (authToken != "" && authToken != null) {
        yield AppAuthenticated();
      } else {
        yield AuthenticationStart();
      }
    } catch (e) {
      yield AuthenticationFailure(message: e.toString());
    }
  }

  Stream<AuthenticationState> _mapUserLoginState(UserLogin event) async* {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    yield AuthenticationLoading();
    try {
      Response response = await authenticationService.loginWithEmailAndPassword(
          event.email, event.password);
      if (response.data["error"] == null) {
        final currentUser = UserModel.fromJson(response.data);
        if (currentUser != null) {
          sharedPreferences.setString('authToken', currentUser.accessToken!);
          sharedPreferences.setInt("userId", currentUser.user!.id!);
          // sharedPreferences.setInt('policeStationId', currentUser.user!.psid!);
          yield AppAuthenticated();
        } else {
          yield AuthenticationNotAuthenticated();
        }
      } else {
        yield AuthenticationFailure(message: response.data["error"]);
      }
    } catch (e) {
      yield AuthenticationFailure(message: e.toString());
    }
  }
}
