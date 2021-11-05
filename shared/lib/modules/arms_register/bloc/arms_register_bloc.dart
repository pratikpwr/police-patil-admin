import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:shared/modules/arms_register/models/arms_model.dart';
import 'package:shared/modules/arms_register/resources/arms_repository.dart';
import 'package:shared/shared.dart';

part 'arms_register_event.dart';

part 'arms_register_state.dart';

class ArmsRegisterBloc extends Bloc<ArmsRegisterEvent, ArmsRegisterState> {
  ArmsRegisterBloc() : super(ArmsRegisterInitial());

  final _armsRepository = ArmsRepository();

  @override
  Stream<ArmsRegisterState> mapEventToState(
    ArmsRegisterEvent event,
  ) async* {
    if (event is GetArmsData) {
      yield* _mapGetArmsDataState(event);
    }
  }

  String? village;
  String? chosenType;
  final List<String> types = <String>[
    "सर्व",
    "शस्त्र परवानाधारक",
    "स्फोटक पदार्थ विक्री",
    "स्फोटक जवळ बाळगणारे",
    "स्फोटक उडविणारे"
  ];


  List<ArmsData> typeWiseData(List<ArmsData> data) {
    List<ArmsData> newData = [];

    for (int i = 0; i < types.length; i++) {
      if (chosenType == types[0]) {
        return data;
      }
      if (chosenType == types[i]) {
        newData.addAll(data.where((element) => element.type == types[i]));
        return newData;
      }
    }
    return data;
  }

  Stream<ArmsRegisterState> _mapGetArmsDataState(GetArmsData event) async* {
    yield ArmsDataLoading();
    try {
      if (event.type == "सर्व") {
        event.type = "";
      }
      String? params = "?type=${event.type ?? ""}&psid=${event.psId ?? ""}";
      Response _response =
          await _armsRepository.getArmsRegister(params: params);
      if (_response.data["message"] != null) {
        final _armsResponse = ArmsResponse.fromJson(_response.data);
        yield ArmsDataLoaded(_armsResponse);
      } else {
        yield ArmsLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield ArmsLoadError(err.toString());
    }
  }
}
