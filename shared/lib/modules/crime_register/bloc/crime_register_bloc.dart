import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/crime_register/models/crime_model.dart';
import 'package:dio/dio.dart';
import 'package:shared/modules/crime_register/resources/crime_repository.dart';
import '../../../shared.dart';

part 'crime_register_event.dart';

part 'crime_register_state.dart';

class CrimeRegisterBloc extends Bloc<CrimeRegisterEvent, CrimeRegisterState> {
  CrimeRegisterBloc() : super(CrimeRegisterInitial());
  final _crimeRepository = CrimeRepository();

  @override
  Stream<CrimeRegisterState> mapEventToState(
    CrimeRegisterEvent event,
  ) async* {
    if (event is GetCrimeData) {
      yield* _mapGetCrimeDataState(event);
    }
    if (event is AddCrimeData) {
      yield* _mapAddCrimeDataState(event);
    }
  }

  String? value;
  final List<String> types = <String>[
    "सर्व",
    "शरीरा विरुद्ध",
    "माला विरुद्ध",
    "महिलांविरुद्ध",
    "अपघात",
    "इतर अपराध"
  ];

  List<CrimeData> typeWiseData(List<CrimeData> data) {
    List<CrimeData> newData = [];

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

  Stream<CrimeRegisterState> _mapGetCrimeDataState(GetCrimeData event) async* {
    yield CrimeDataLoading();
    try {
      Response _response = await _crimeRepository.getCrimeRegister();
      if (_response.statusCode! < 400) {
        final _crimeResponse = CrimeResponse.fromJson(_response.data);
        yield CrimeDataLoaded(_crimeResponse);
      } else {
        yield CrimeLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield CrimeLoadError(err.toString());
    }
  }

  Stream<CrimeRegisterState> _mapAddCrimeDataState(AddCrimeData event) async* {
    yield CrimeDataSending();
    try {
      final sharedPrefs = await prefs;
      event.crimeData.ppid = sharedPrefs.getInt('userId')!;
      event.crimeData.psid = sharedPrefs.getInt('policeStationId')!;

      Response _response =
          await _crimeRepository.addCrimeData(crimeData: event.crimeData);

      if (_response.data["message"] != null) {
        yield CrimeDataSent(_response.data["message"]);
      } else {
        yield CrimeDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield CrimeDataSendError(err.toString());
    }
  }
}
