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
        HomeData? homeData;

        Response watchRes = await _homeRepository.getLatestWatch();
        Response moveRes = await _homeRepository.getLatestMovement();
        Response illRes = await _homeRepository.getLatestIllegal();
        Response ppRes = await _homeRepository.getTopPP();

        if (ppRes.data["message"] != null) {
          homeData?.topPP = UsersResponse.fromJson(ppRes.data).data;
        }
        if (illRes.data["message"] != null) {
          homeData?.latestIllegal = IllegalResponse.fromJson(ppRes.data).data;
        }
        if (moveRes.data["message"] != null) {
          homeData?.latestMovement =
              MovementResponse.fromJson(ppRes.data).movementData;
        }
        if (watchRes.data["message"] != null) {
          homeData?.latestWatch = WatchResponse.fromJson(ppRes.data).data;
        }
        yield HomeSuccess(homeData!);
      } catch (err) {
        yield HomeError(err.toString());
      }
    }
  }
}
