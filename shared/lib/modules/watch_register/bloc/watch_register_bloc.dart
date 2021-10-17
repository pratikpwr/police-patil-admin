import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/watch_register/models/watch_model.dart';
import 'package:dio/dio.dart';
import 'package:shared/modules/watch_register/resources/watch_repository.dart';
import '../../../shared.dart';

part 'watch_register_event.dart';

part 'watch_register_state.dart';

class WatchRegisterBloc extends Bloc<WatchRegisterEvent, WatchRegisterState> {
  WatchRegisterBloc() : super(WatchRegisterInitial());
  final _watchRepository = WatchRepository();

  @override
  Stream<WatchRegisterState> mapEventToState(
    WatchRegisterEvent event,
  ) async* {
    if (event is GetWatchData) {
      yield* _mapGetWatchDataState(event);
    }
    if (event is AddWatchData) {
      yield* _mapAddWatchDataState(event);
    }
  }

  String? value;
  final List<String> types = <String>[
    "सर्व",
    "भटक्या टोळी",
    "सराईत गुन्हेगार",
    "फरार आरोपी",
    "तडीपार आरोपी",
    "स्टॅंडिंग वॉरंट"
  ];

  List<WatchData> typeWiseData(List<WatchData> data) {
    List<WatchData> newData = [];

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

  Stream<WatchRegisterState> _mapGetWatchDataState(GetWatchData event) async* {
    yield WatchDataLoading();
    try {
      Response _response = await _watchRepository.getWatchRegister();
      if (_response.statusCode! < 400) {
        final _watchResponse = WatchResponse.fromJson(_response.data);
        yield WatchDataLoaded(_watchResponse);
      } else {
        yield WatchLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield WatchLoadError(err.toString());
    }
  }

  Stream<WatchRegisterState> _mapAddWatchDataState(AddWatchData event) async* {
    yield WatchDataSending();
    try {
      final sharedPrefs = await prefs;
      event.watchData.ppid = sharedPrefs.getInt('userId')!;
      event.watchData.psid = sharedPrefs.getInt('policeStationId')!;

      Response _response =
          await _watchRepository.addWatchData(watchData: event.watchData);

      if (_response.data["message"] != null) {
        yield WatchDataSent(_response.data["message"]);
      } else {
        yield WatchDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield WatchDataSendError(err.toString());
    }
  }
}
