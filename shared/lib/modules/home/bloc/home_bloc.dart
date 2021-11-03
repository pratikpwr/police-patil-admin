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
        Response watchRes = await _homeRepository.getLatestWatch();
        Response moveRes = await _homeRepository.getLatestMovement();
        Response illRes = await _homeRepository.getLatestIllegal();
        Response ppRes = await _homeRepository.getTopPP();
        var topPP;
        var latestIllegal;
        var latestWatch;
        var latestMovement;
        if (ppRes.data["message"] != null) {
          topPP = UsersResponse.fromJson(ppRes.data).data;
        }
        if (illRes.data["message"] != null) {
          latestIllegal = IllegalResponse.fromJson(illRes.data).data;
        }
        if (moveRes.data["message"] != null) {
          latestMovement = MovementResponse.fromJson(moveRes.data).movementData;
        }
        if (watchRes.data["message"] != null) {
          latestWatch = WatchResponse.fromJson(watchRes.data).data;
        }
        HomeData homeData = HomeData(
            topPP: topPP,
            latestIllegal: latestIllegal,
            latestMovement: latestMovement,
            latestWatch: latestWatch);
        yield HomeSuccess(homeData);
      } catch (err) {
        yield HomeError(err.toString());
      }
    }
  }
}
