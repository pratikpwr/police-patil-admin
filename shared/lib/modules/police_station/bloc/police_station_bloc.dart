import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/police_station/police_station.dart';
import 'package:dio/dio.dart';

part 'police_station_event.dart';

part 'police_station_state.dart';

class PoliceStationBloc extends Bloc<PoliceStationEvent, PoliceStationState> {
  PoliceStationBloc() : super(PoliceStationInitial());

  final _psRepository = PoliceStationRepository();

  @override
  Stream<PoliceStationState> mapEventToState(
    PoliceStationEvent event,
  ) async* {
    if (event is GetPoliceStation) {
      yield* _mapGetPoliceStationDataState(event);
    }
    if (event is AddPoliceStation) {
      yield* _mapAddPoliceStationDataState(event);
    }
  }

  Stream<PoliceStationState> _mapGetPoliceStationDataState(
      GetPoliceStation event) async* {
    yield PoliceStationDataLoading();
    try {
      Response _response = await _psRepository.getPoliceStations();
      if (_response.data["message"] != null) {
        final _psResponse = PoliceStationResponse.fromJson(_response.data);
        yield PoliceStationDataLoaded(_psResponse);
      } else {
        yield PoliceStationLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield PoliceStationLoadError(err.toString());
    }
  }

  Stream<PoliceStationState> _mapAddPoliceStationDataState(
      AddPoliceStation event) async* {
    yield PoliceStationDataSending();
    try {
      Response _response = await _psRepository.addPoliceStation(event.psData);

      if (_response.data["message"] != null) {
        yield PoliceStationDataSent(_response.data["message"]);
      } else {
        yield PoliceStationDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield PoliceStationDataSendError(err.toString());
    }
  }
}
