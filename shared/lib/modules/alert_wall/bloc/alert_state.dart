part of 'alert_bloc.dart';

abstract class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object> get props => [];
}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {}

class AlertLoaded extends AlertState {
  final AlertResponse alertResponse;

  const AlertLoaded(this.alertResponse);

  @override
  List<Object> get props => [alertResponse];
}

class AlertLoadError extends AlertState {
  final String error;

  const AlertLoadError(this.error);

  @override
  List<Object> get props => [error];
}

class AlertDataSending extends AlertState {}

class AlertDataSent extends AlertState {
  final String message;

  const AlertDataSent(this.message);
}

class AlertDataSendError extends AlertState {
  final String error;

  const AlertDataSendError(this.error);
}
