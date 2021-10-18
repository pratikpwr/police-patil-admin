part of 'police_station_bloc.dart';

abstract class PoliceStationState extends Equatable {
  const PoliceStationState();

  @override
  List<Object> get props => [];
}

class PoliceStationInitial extends PoliceStationState {}

class PoliceStationDataLoading extends PoliceStationState {}

class PoliceStationDataLoaded extends PoliceStationState {
  final PoliceStationResponse psResponse;

  const PoliceStationDataLoaded(this.psResponse);

  @override
  List<Object> get props => [psResponse];
}

class PoliceStationLoadError extends PoliceStationState {
  final String message;

  const PoliceStationLoadError(this.message);
}

class PoliceStationDataSending extends PoliceStationState {}

class PoliceStationDataSent extends PoliceStationState {
  final String message;

  const PoliceStationDataSent(this.message);
}

class PoliceStationDataSendError extends PoliceStationState {
  final String error;

  const PoliceStationDataSendError(this.error);
}
