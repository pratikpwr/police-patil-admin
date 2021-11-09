part of 'public_place_register_bloc.dart';

abstract class PublicPlaceRegisterEvent extends Equatable {
  const PublicPlaceRegisterEvent();

  @override
  List<Object> get props => [];
}

class GetPublicPlaceData extends PublicPlaceRegisterEvent {
  String? type, psId, ppId, fromDate, toDate;

  GetPublicPlaceData(
      {this.type, this.psId, this.ppId, this.fromDate, this.toDate});
}

class AddPublicPlaceData extends PublicPlaceRegisterEvent {
  final PlaceData placeData;

  const AddPublicPlaceData(this.placeData);

  @override
  List<Object> get props => [placeData];
}
