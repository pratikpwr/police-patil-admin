import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/public_place_register/models/public_place_model.dart';
import 'package:shared/modules/public_place_register/resources/public_place_repository.dart';
import 'package:dio/dio.dart';
import '../../../shared.dart';

part 'public_place_register_event.dart';

part 'public_place_register_state.dart';

class PublicPlaceRegisterBloc
    extends Bloc<PublicPlaceRegisterEvent, PublicPlaceRegisterState> {
  PublicPlaceRegisterBloc() : super(PublicPlaceRegisterInitial());
  final _placeRepository = PlaceRepository();
  String? chosenType, psId, ppId, fromDate, toDate;
  final List<String> placeTypes = <String>[
    "सर्व",
    "रस्ता",
    "पाणवठा",
    "जमीन",
    "पुतळा",
    "धार्मिक स्थळ"
  ];

  @override
  Stream<PublicPlaceRegisterState> mapEventToState(
    PublicPlaceRegisterEvent event,
  ) async* {
    if (event is GetPublicPlaceData) {
      yield* _mapGetPublicPlaceDataState(event);
    }
    if (event is AddPublicPlaceData) {
      yield* _mapAddPublicPlaceDataState(event);
    }
  }

  Stream<PublicPlaceRegisterState> _mapGetPublicPlaceDataState(
      GetPublicPlaceData event) async* {
    yield PublicPlaceDataLoading();
    try {
      String? params = getParams(event);
      Response _response =
          await _placeRepository.getPlaceRegister(params: params);
      if (_response.statusCode! < 400) {
        final _placeResponse = PlaceResponse.fromJson(_response.data);
        yield PublicPlaceDataLoaded(_placeResponse);
      } else {
        yield PublicPlaceLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield PublicPlaceLoadError(err.toString());
    }
  }

  Stream<PublicPlaceRegisterState> _mapAddPublicPlaceDataState(
      AddPublicPlaceData event) async* {
    yield PublicPlaceDataSending();
    try {
      final sharedPrefs = await prefs;
      event.placeData.ppid = sharedPrefs.getInt('userId')!;
      event.placeData.psid = sharedPrefs.getInt('policeStationId')!;

      Response _response =
          await _placeRepository.addPlaceData(placeData: event.placeData);

      if (_response.data["message"] != null) {
        yield PublicPlaceDataSent(_response.data["message"]);
      } else {
        yield PublicPlaceDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield PublicPlaceDataSendError(err.toString());
    }
  }

  String getParams(GetPublicPlaceData event) {
    String _params = "?";

    if (event.type != null) {
      if (event.type == "सर्व") {
        _params += "";
      } else {
        _params += "place=${event.type}&";
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
