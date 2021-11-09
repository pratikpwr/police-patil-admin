import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/movement_register/models/movement_model.dart';
import 'package:shared/modules/movement_register/resources/movement_repository.dart';
import 'package:dio/dio.dart';
import '../../../shared.dart';

part 'movement_register_event.dart';

part 'movement_register_state.dart';

class MovementRegisterBloc
    extends Bloc<MovementRegisterEvent, MovementRegisterState> {
  MovementRegisterBloc() : super(MovementRegisterInitial());
  final _movementRepository = MovementRepository();

  @override
  Stream<MovementRegisterState> mapEventToState(
    MovementRegisterEvent event,
  ) async* {
    if (event is GetMovementData) {
      yield* _mapGetMovementDataState(event);
    }
    if (event is AddMovementData) {
      yield* _mapAddMovementDataState(event);
    }
  }

  String? chosenType, psId, ppId, fromDate, toDate;
  final List<String> types = <String>[
    "सर्व",
    "राजकीय हालचाली",
    "धार्मिक हालचाली",
    "जातीय हालचाली",
    "सांस्कृतिक हालचाली"
  ];

  Stream<MovementRegisterState> _mapGetMovementDataState(
      GetMovementData event) async* {
    yield MovementDataLoading();
    try {
      String? params = getParams(event);
      Response _response =
          await _movementRepository.getMovementRegister(params: params);
      if (_response.statusCode! < 400) {
        final _movementResponse = MovementResponse.fromJson(_response.data);
        yield MovementDataLoaded(_movementResponse);
      } else {
        yield MovementLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield MovementLoadError(err.toString());
    }
  }

  Stream<MovementRegisterState> _mapAddMovementDataState(
      AddMovementData event) async* {
    yield MovementDataSending();
    try {
      final sharedPrefs = await prefs;
      event.movementData.ppid = sharedPrefs.getInt('userId')!;
      event.movementData.psid = sharedPrefs.getInt('policeStationId')!;

      Response _response = await _movementRepository.addMovementData(
          movementData: event.movementData);

      if (_response.data["message"] != null) {
        yield MovementDataSent(_response.data["message"]);
      } else {
        yield MovementDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield MovementDataSendError(err.toString());
    }
  }

  String getParams(GetMovementData event) {
    String _params = "?";

    if (event.type != null) {
      if (event.type == "सर्व") {
        _params += "";
      } else {
        _params += "type=${event.type}&";
      }
    }
    if (event.psId != null) {
      _params += "psid=${event.psId}&";
    }
    if (event.ppId != null) {
      _params += "ppid=${event.ppId}&";
    }
    if (event.fromDate != null && event.fromDate != "") {
      _params += "fromdate=${event.fromDate}&";
    }
    if (event.toDate != null && event.toDate != "") {
      _params += "todate=${event.toDate}&";
    }
    return _params;
  }
}
