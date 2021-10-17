import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/modules/collection_register/models/collect_model.dart';
import 'package:shared/modules/collection_register/resources/collect_repository.dart';
import 'package:dio/dio.dart';
import '../../../shared.dart';

part 'collect_register_event.dart';

part 'collect_register_state.dart';

class CollectRegisterBloc
    extends Bloc<CollectRegisterEvent, CollectRegisterState> {
  CollectRegisterBloc() : super(CollectionRegisterInitial());
  final _collectionRepository = CollectRepository();

  @override
  Stream<CollectRegisterState> mapEventToState(
    CollectRegisterEvent event,
  ) async* {
    if (event is GetCollectionData) {
      yield* _mapGetCollectionDataState(event);
    }
    if (event is AddCollectionData) {
      yield* _mapAddCollectionDataState(event);
    }
  }

  String? value;
  final List<String> types = <String>[
    "सर्व",
    "बेवारस वाहने",
    "दागिने",
    "गौण खनिज",
    "इतर"
  ];

  List<CollectionData> typeWiseData(List<CollectionData> data) {
    List<CollectionData> newData = [];

    for (int i = 0; i < types.length; i++) {
      if (value == types[0]) {
        return data;
      }
      if (value == types[i]) {
        newData.addAll(data.where((element) => element.type == types[i]));
        return newData;
      }
    }
    return data;
  }

  Stream<CollectRegisterState> _mapGetCollectionDataState(
      GetCollectionData event) async* {
    yield CollectionDataLoading();
    try {
      Response _response = await _collectionRepository.getCollectionsRegister();
      if (_response.statusCode! < 400) {
        final _collectionResponse = CollectionResponse.fromJson(_response.data);
        yield CollectionDataLoaded(_collectionResponse);
      } else {
        yield CollectionLoadError(_response.data["error"]);
      }
    } catch (err) {
      yield CollectionLoadError(err.toString());
    }
  }

  Stream<CollectRegisterState> _mapAddCollectionDataState(
      AddCollectionData event) async* {
    yield CollectionDataSending();
    try {
      final sharedPrefs = await prefs;
      event.collectionData.ppid = sharedPrefs.getInt('userId')!;
      event.collectionData.psid = sharedPrefs.getInt('policeStationId')!;

      Response _response = await _collectionRepository.addCollectionsData(
          collectionData: event.collectionData);

      if (_response.data["message"] != null) {
        yield CollectionDataSent(_response.data["message"]);
      } else {
        yield CollectionDataSendError(_response.data["error"]);
      }
    } catch (err) {
      yield CollectionDataSendError(err.toString());
    }
  }
}
