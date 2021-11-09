part of 'missing_register_bloc.dart';

abstract class MissingRegisterEvent extends Equatable {
  const MissingRegisterEvent();

  @override
  List<Object> get props => [];
}

class GetMissingData extends MissingRegisterEvent {
  String? type, psId, ppId, fromDate, toDate;

  GetMissingData({this.type, this.psId, this.ppId, this.fromDate, this.toDate});
}

class AddMissingData extends MissingRegisterEvent {
  final MissingData missingData;

  const AddMissingData(this.missingData);

  @override
  List<Object> get props => [missingData];
}
