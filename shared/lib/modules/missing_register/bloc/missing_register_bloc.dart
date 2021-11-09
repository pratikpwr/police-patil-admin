import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/missing_register/models/missing_model.dart';
import 'package:shared/modules/missing_register/resources/missing_repository.dart';
import 'package:dio/dio.dart';
import '../../../shared.dart';

part 'missing_register_event.dart';

part 'missing_register_state.dart';

class MissingRegisterBloc
    extends Bloc<MissingRegisterEvent, MissingRegisterState> {
  MissingRegisterBloc() : super(MissingRegisterInitial());
  final _missingRepository = MissingRepository();

  @override
  Stream<MissingRegisterState> mapEventToState(
    MissingRegisterEvent event,
  ) async* {
    if (event is GetMissingData) {
      yield* _mapGetMissingDataState(event);
    }
    if (event is AddMissingData) {
      yield* _mapAddMissingDataState(event);
    }
  }

  Stream<MissingRegisterState> _mapGetMissingDataState(
      GetMissingData event) async* {
    yield MissingDataLoading();
    try {
      String? params = getParams(event);
      Response _response =
          await _missingRepository.getMissingRegister(params: params);
      if (_response.statusCode! < 400) {
        final _missingResponse = MissingResponse.fromJson(_response.data);
        yield MissingDataLoaded(_missingResponse);
      } else {
        yield MissingLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield MissingLoadError(err.toString());
    }
  }

  Stream<MissingRegisterState> _mapAddMissingDataState(
      AddMissingData event) async* {
    yield MissingDataSending();
    try {
      final sharedPrefs = await prefs;
      event.missingData.ppid = sharedPrefs.getInt('userId')!;
      event.missingData.psid = sharedPrefs.getInt('policeStationId')!;

      Response _response = await _missingRepository.addMissingData(
          missingData: event.missingData);

      if (_response.data["message"] != null) {
        yield MissingDataSent(_response.data["message"]);
      } else {
        yield MissingDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield MissingDataSendError(err.toString());
    }
  }

  String? chosenType, isKnown, psId, ppId, fromDate, toDate;
  final List<String> types = <String>["सर्व", "पुरुष", "स्त्री"];

  String getParams(GetMissingData event) {
    String _params = "?";

    if (event.type != null) {
      if (event.type == "सर्व") {
        _params += "";
      } else {
        _params += "gender=${event.type}&";
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
