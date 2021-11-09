part of 'movement_register_bloc.dart';

abstract class MovementRegisterEvent extends Equatable {
  const MovementRegisterEvent();

  @override
  List<Object> get props => [];
}

class GetMovementData extends MovementRegisterEvent {
  String? type, psId, ppId, fromDate, toDate;

  GetMovementData(
      {this.type, this.psId, this.ppId, this.fromDate, this.toDate});
}

class AddMovementData extends MovementRegisterEvent {
  final MovementData movementData;

  const AddMovementData(this.movementData);

  @override
  List<Object> get props => [movementData];
}
