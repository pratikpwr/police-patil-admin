part of 'alert_bloc.dart';

abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object> get props => [];
}

class GetAlerts extends AlertEvent {}

class AddAlert extends AlertEvent {
  final AlertData alertData;

  const AddAlert(this.alertData);

  @override
  List<Object> get props => [alertData];
}
