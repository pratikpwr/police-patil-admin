import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/disaster_helper/disaster_helper.dart';
import 'package:shared/modules/disaster_helper/models/helper_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

part 'disaster_helper_event.dart';

part 'disaster_helper_state.dart';

class DisasterHelperBloc
    extends Bloc<DisasterHelperEvent, DisasterHelperState> {
  DisasterHelperBloc() : super(DisasterHelperInitial());

  final _helperRepository = DisasterHelperRepository();

  @override
  Stream<DisasterHelperState> mapEventToState(
    DisasterHelperEvent event,
  ) async* {
    if (event is GetHelperData) {
      yield* _mapGetDisasterDataState(event);
    }
  }

  Stream<DisasterHelperState> _mapGetDisasterDataState(
      GetHelperData event) async* {
    yield HelperDataLoading();
    try {
      Response _response = await _helperRepository.getDisasterHelper();
      if (_response.statusCode! < 400) {
        final _helperResponse = HelperResponse.fromJson(_response.data);
        yield HelperDataLoaded(_helperResponse);
      } else {
        yield HelperLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield HelperLoadError(err.toString());
    }
  }
}
