part of 'crime_register_bloc.dart';

abstract class CrimeRegisterEvent extends Equatable {
  const CrimeRegisterEvent();

  @override
  List<Object> get props => [];
}

class GetCrimeData extends CrimeRegisterEvent {
  String? type, psId, ppId, fromDate, toDate;

  GetCrimeData({this.type, this.psId, this.ppId, this.fromDate, this.toDate});
}

class AddCrimeData extends CrimeRegisterEvent {
  final CrimeData crimeData;

  const AddCrimeData(this.crimeData);

  @override
  List<Object> get props => [crimeData];
}
