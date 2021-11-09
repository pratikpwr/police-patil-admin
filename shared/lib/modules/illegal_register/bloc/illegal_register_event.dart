part of 'illegal_register_bloc.dart';

abstract class IllegalRegisterEvent extends Equatable {
  const IllegalRegisterEvent();

  @override
  List<Object> get props => [];
}

class GetIllegalData extends IllegalRegisterEvent {
  String? type, psId, ppId, fromDate, toDate;

  GetIllegalData({this.type, this.psId, this.ppId, this.fromDate, this.toDate});
}

class AddIllegalData extends IllegalRegisterEvent {
  final IllegalData illegalData;

  const AddIllegalData(this.illegalData);

  @override
  List<Object> get props => [illegalData];
}
