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

  String? value;
  final List<String> types = <String>[
    "सर्व",
    "राजकीय हालचाली",
    "धार्मिक हालचाली",
    "जातीय हालचाली",
    "सांस्कृतिक हालचाली"
  ];

  List<MovementData> typeWiseData(List<MovementData> data) {
    List<MovementData> newData = [];

    for (int i = 0; i < types.length; i++) {
      if (value == types[0]) {
        return data;
      }
      if (value == types[i]) {
        newData.addAll(data.where((element) => element.type == types[i]));
        return newData;
      }
    }
    return data;
  }

  Stream<MovementRegisterState> _mapGetMovementDataState(
      GetMovementData event) async* {
    yield MovementDataLoading();
    try {
      Response _response = await _movementRepository.getMovementRegister();
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
}
