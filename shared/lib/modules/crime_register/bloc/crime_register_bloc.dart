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

  String? chosenType, psId, ppId, fromDate, toDate;
  final List<String> types = <String>[
    "सर्व",
    "शरीरा विरुद्ध",
    "माला विरुद्ध",
    "महिलांविरुद्ध",
    "अपघात",
    "इतर अपराध"
  ];

  Stream<CrimeRegisterState> _mapGetCrimeDataState(GetCrimeData event) async* {
    yield CrimeDataLoading();
    try {
      String? params = getParams(event);
      Response _response =
          await _crimeRepository.getCrimeRegister(params: params);
      if (_response.data["message"] != null) {
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

  String getParams(GetCrimeData event) {
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
