import 'dart:async';
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/home/home.dart';
import 'package:shared/modules/home/models/home_mode.dart';
import 'package:shared/shared.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());
  final _homeRepository = HomeRepository();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetHomeData) {
      yield HomeLoading();
      try {
        Response _res = await _homeRepository.getHomeData();

        if (_res.data["message"] != null) {
          final homeData = HomeResponse.fromJson(_res.data).data;
          yield HomeSuccess(homeData);
        }
      } catch (err) {
        yield HomeError(err.toString());
      }
    }
  }
}
