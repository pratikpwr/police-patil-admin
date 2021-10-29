import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/kayade/kayade.dart';
import 'package:shared/modules/kayade/models/kayade_model.dart';
import 'package:dio/dio.dart';

part 'kayade_event.dart';

part 'kayade_state.dart';

class KayadeBloc extends Bloc<KayadeEvent, KayadeState> {
  KayadeBloc() : super(KayadeInitial());
  final _kayadeRepository = KayadeRepository();

  @override
  Stream<KayadeState> mapEventToState(
    KayadeEvent event,
  ) async* {
    if (event is GetKayade) {
      yield KayadeLoading();
      try {
        Response _response = await _kayadeRepository.getKayade();
        if (_response.data["error"] == null) {
          final _kayade = KayadeResponse.fromJson(_response.data);
          yield KayadeLoaded(_kayade);
        } else {
          yield KayadeLoadError(_response.data["error"].toString());
        }
      } catch (err) {
        yield KayadeLoadError(err.toString());
      }
    }
    if (event is AddKayade) {
      try {
        Response _response =
            await _kayadeRepository.addKayadeData(body: event.kayadeData);

        if (_response.data["message"] != null) {
          yield KayadeDataSent(_response.data["message"]);
        } else {
          yield KayadeDataSendError(_response.data["error"]);
        }
      } catch (err) {
        yield KayadeDataSendError(err.toString());
      }
    }
  }
}
