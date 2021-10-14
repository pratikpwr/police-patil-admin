import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/alert_wall/models/alert_model.dart';
import 'package:shared/modules/alert_wall/resources/alert_repository.dart';
import 'package:dio/dio.dart';

part 'alert_event.dart';

part 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  AlertBloc() : super(AlertInitial());
  final _alertRepository = AlertRepository();

  @override
  Stream<AlertState> mapEventToState(
    AlertEvent event,
  ) async* {
    if (event is GetAlerts) {
      yield AlertLoading();
      try {
        Response _response = await _alertRepository.getAlerts();
        if (_response.data["error"] == null) {
          final _alert = AlertResponse.fromJson(_response.data);
          yield AlertLoaded(_alert);
        } else {
          yield AlertLoadError(_response.data["error"].toString());
        }
      } catch (err) {
        yield AlertLoadError(err.toString());
      }
    }
    if (event is AddAlert) {
      try {
        Response _response =
            await _alertRepository.addAlertData(alertData: event.alertData);

        if (_response.data["message"] != null) {
          yield AlertDataSent(_response.data["message"]);
        } else {
          yield AlertDataSendError(_response.data["error"]);
        }
      } catch (err) {
        yield AlertDataSendError(err.toString());
      }
    }
  }
}
