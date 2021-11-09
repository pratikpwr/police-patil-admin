part of 'collect_register_bloc.dart';

abstract class CollectRegisterEvent extends Equatable {
  const CollectRegisterEvent();

  @override
  List<Object> get props => [];
}

class GetCollectionData extends CollectRegisterEvent {
  String? type, psId, ppId, fromDate, toDate;

  GetCollectionData(
      {this.type, this.psId, this.ppId, this.fromDate, this.toDate});
}

class AddCollectionData extends CollectRegisterEvent {
  final CollectionData collectionData;

  const AddCollectionData(this.collectionData);

  @override
  List<Object> get props => [collectionData];
}
