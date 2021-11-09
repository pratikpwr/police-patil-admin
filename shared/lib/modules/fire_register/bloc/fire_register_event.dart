part of 'fire_register_bloc.dart';

abstract class FireRegisterEvent extends Equatable {
  const FireRegisterEvent();

  @override
  List<Object> get props => [];
}

class GetFireData extends FireRegisterEvent {
  String? psId, ppId, fromDate, toDate;

  GetFireData({this.psId, this.ppId, this.fromDate, this.toDate});
}

class AddFireData extends FireRegisterEvent {
  final FireData fireData;

  const AddFireData(this.fireData);

  @override
  List<Object> get props => [fireData];
}
