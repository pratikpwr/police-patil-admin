part of 'police_station_bloc.dart';

abstract class PoliceStationEvent extends Equatable {
  const PoliceStationEvent();

  @override
  List<Object?> get props => [];
}

class AddPoliceStation extends PoliceStationEvent {
  final PoliceStationData psData;

  const AddPoliceStation({required this.psData});

  @override
  List<Object?> get props => [psData];
}

class GetPoliceStation extends PoliceStationEvent {}
