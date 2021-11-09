part of 'death_register_bloc.dart';

abstract class DeathRegisterEvent extends Equatable {
  const DeathRegisterEvent();

  @override
  List<Object> get props => [];
}

class GetDeathData extends DeathRegisterEvent {
  String? isKnown, type, psId, ppId, fromDate, toDate;

  GetDeathData(
      {this.type,
      this.isKnown,
      this.psId,
      this.ppId,
      this.fromDate,
      this.toDate});
}

class AddDeathData extends DeathRegisterEvent {
  final DeathData deathData;

  const AddDeathData(this.deathData);

  @override
  List<Object> get props => [deathData];
}
