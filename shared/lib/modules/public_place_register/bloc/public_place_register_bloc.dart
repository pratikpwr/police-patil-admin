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
  String? chosenValue;
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
      Response _response = await _placeRepository.getPlaceRegister();
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

  List<PlaceData> typeWiseData(List<PlaceData> data) {
    List<PlaceData> newData = [];

    for (int i = 0; i < placeTypes.length; i++) {
      if (chosenValue == placeTypes[0]) {
        return data;
      }
      if (chosenValue == placeTypes[i]) {
        newData.addAll(data.where((element) => element.place == placeTypes[i]));
        return newData;
      }
    }
    return data;
  }
}
