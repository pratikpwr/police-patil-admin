import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/fire_register/models/fire_model.dart';
import 'package:shared/modules/fire_register/resources/fire_repository.dart';
import 'package:dio/dio.dart';
import '../../../shared.dart';

part 'fire_register_event.dart';

part 'fire_register_state.dart';

class FireRegisterBloc extends Bloc<FireRegisterEvent, FireRegisterState> {
  FireRegisterBloc() : super(FireRegisterInitial());
  final _fireRepository = FireRepository();

  String? psId, ppId, fromDate, toDate;

  @override
  Stream<FireRegisterState> mapEventToState(
    FireRegisterEvent event,
  ) async* {
    if (event is GetFireData) {
      yield* _mapGetFireDataState(event);
    }
    if (event is AddFireData) {
      yield* _mapAddFireDataState(event);
    }
  }

  Stream<FireRegisterState> _mapGetFireDataState(GetFireData event) async* {
    yield FireDataLoading();
    try {
      String? params = getParams(event);
      Response _response =
          await _fireRepository.getFireRegister(params: params);
      if (_response.statusCode! < 400) {
        final _fireResponse = FireResponse.fromJson(_response.data);
        yield FireDataLoaded(_fireResponse);
      } else {
        yield FireLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield FireLoadError(err.toString());
    }
  }

  Stream<FireRegisterState> _mapAddFireDataState(AddFireData event) async* {
    yield FireDataSending();
    try {
      final sharedPrefs = await prefs;
      event.fireData.ppid = sharedPrefs.getInt('userId')!;
      event.fireData.psid = sharedPrefs.getInt('policeStationId')!;

      Response _response =
          await _fireRepository.addFireData(fireData: event.fireData);

      if (_response.data["message"] != null) {
        yield FireDataSent(_response.data["message"]);
      } else {
        yield FireDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield FireDataSendError(err.toString());
    }
  }

  String getParams(GetFireData event) {
    String _params = "?";

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
