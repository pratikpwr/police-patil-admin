import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/illegal_register/models/illegal_model.dart';
import 'package:dio/dio.dart';
import 'package:shared/modules/illegal_register/resources/illegal_repository.dart';
import '../../../shared.dart';

part 'illegal_register_event.dart';

part 'illegal_register_state.dart';

class IllegalRegisterBloc
    extends Bloc<IllegalRegisterEvent, IllegalRegisterState> {
  IllegalRegisterBloc() : super(IllegalRegisterInitial());

  final _illegalRepository = IllegalRepository();

  @override
  Stream<IllegalRegisterState> mapEventToState(
    IllegalRegisterEvent event,
  ) async* {
    if (event is GetIllegalData) {
      yield* _mapGetIllegalDataState(event);
    }
    if (event is AddIllegalData) {
      yield* _mapAddIllegalDataState(event);
    }
  }

  String? chosenType, psId, ppId, fromDate, toDate;
  final List<String> types = <String>[
    "सर्व",
    "अवैद्य दारू विक्री करणारे",
    "अवैद्य गुटका विक्री करणारे",
    "जुगार/मटका चालविणारे/खेळणारे",
    "अवैद्य गौण खनिज उत्खनन करणारे वाळू तस्कर",
    "अमली पदार्थ विक्री करणारे"
  ];

  Stream<IllegalRegisterState> _mapGetIllegalDataState(
      GetIllegalData event) async* {
    yield IllegalDataLoading();
    try {
      String? params = getParams(event);
      Response _response =
          await _illegalRepository.getIllegalRegister(params: params);
      if (_response.statusCode! < 400) {
        final _illegalResponse = IllegalResponse.fromJson(_response.data);
        yield IllegalDataLoaded(_illegalResponse);
      } else {
        yield IllegalLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield IllegalLoadError(err.toString());
    }
  }

  Stream<IllegalRegisterState> _mapAddIllegalDataState(
      AddIllegalData event) async* {
    yield IllegalDataSending();
    try {
      final sharedPrefs = await prefs;
      event.illegalData.ppid = sharedPrefs.getInt('userId')!;
      event.illegalData.psid = sharedPrefs.getInt('policeStationId')!;

      Response _response = await _illegalRepository.addIllegalData(
          illegalData: event.illegalData);

      if (_response.data["message"] != null) {
        yield IllegalDataSent(_response.data["message"]);
      } else {
        yield IllegalDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield IllegalDataSendError(err.toString());
    }
  }

  String getParams(GetIllegalData event) {
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
