import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/death_register/models/death_model.dart';
import 'package:dio/dio.dart';
import 'package:shared/modules/death_register/resources/death_repository.dart';
import '../../../shared.dart';

part 'death_register_event.dart';

part 'death_register_state.dart';

class DeathRegisterBloc extends Bloc<DeathRegisterEvent, DeathRegisterState> {
  DeathRegisterBloc() : super(DeathRegisterInitial());
  final _deathRepository = DeathRepository();

  String? chosenType, isKnown, psId, ppId, fromDate, toDate;
  final List<String> types = <String>["सर्व", "पुरुष", "स्त्री"];

  @override
  Stream<DeathRegisterState> mapEventToState(
    DeathRegisterEvent event,
  ) async* {
    if (event is GetDeathData) {
      yield* _mapGetDeathDataState(event);
    }
    if (event is AddDeathData) {
      yield* _mapAddDeathDataState(event);
    }
  }

  Stream<DeathRegisterState> _mapGetDeathDataState(GetDeathData event) async* {
    yield DeathDataLoading();
    try {
      String? params = getParams(event);
      Response _response =
          await _deathRepository.getDeathRegister(params: params);
      if (_response.statusCode! < 400) {
        final _deathResponse = DeathResponse.fromJson(_response.data);
        yield DeathDataLoaded(_deathResponse);
      } else {
        yield DeathLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield DeathLoadError(err.toString());
    }
  }

  Stream<DeathRegisterState> _mapAddDeathDataState(AddDeathData event) async* {
    yield DeathDataSending();
    try {
      final sharedPrefs = await prefs;
      event.deathData.ppid = sharedPrefs.getInt('userId')!;
      event.deathData.psid = sharedPrefs.getInt('policeStationId')!;

      Response _response =
          await _deathRepository.addDeathData(deathData: event.deathData);

      if (_response.data["message"] != null) {
        yield DeathDataSent(_response.data["message"]);
      } else {
        yield DeathDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield DeathDataSendError(err.toString());
    }
  }

  String getParams(GetDeathData event) {
    String _params = "?";

    if (event.type != null) {
      if (event.type == "सर्व") {
        _params += "";
      } else {
        _params += "gender=${event.type}&";
      }
    }
    if (event.isKnown != null) {
      _params += "isknown=${event.isKnown}&";
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
