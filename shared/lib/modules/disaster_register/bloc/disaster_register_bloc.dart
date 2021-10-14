import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/disaster_register/models/disaster_model.dart';
import 'package:dio/dio.dart';
import 'package:shared/modules/disaster_register/resources/disaster_repository.dart';

part 'disaster_register_event.dart';

part 'disaster_register_state.dart';

class DisasterRegisterBloc
    extends Bloc<DisasterRegisterEvent, DisasterRegisterState> {
  DisasterRegisterBloc() : super(DisasterRegisterInitial());
  final _disasterRepository = DisasterRepository();

  @override
  Stream<DisasterRegisterState> mapEventToState(
    DisasterRegisterEvent event,
  ) async* {
    if (event is GetDisasterData) {
      yield* _mapGetDisasterDataState(event);
    }
  }

  Stream<DisasterRegisterState> _mapGetDisasterDataState(
      GetDisasterData event) async* {
    yield DisasterDataLoading();
    try {
      Response _response = await _disasterRepository.getDisasterRegister();
      if (_response.statusCode! < 400) {
        final _disasterResponse = DisasterResponse.fromJson(_response.data);
        yield DisasterDataLoaded(_disasterResponse);
      } else {
        yield DisasterLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield DisasterLoadError(err.toString());
    }
  }
}
