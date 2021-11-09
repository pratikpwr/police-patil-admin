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

  String? chosenType, psId, ppId, fromDate, toDate;
  final List<String> types = <String>[
    "सर्व",
    "बेवारस वाहने",
    "दागिने",
    "गौण खनिज",
    "इतर"
  ];

  Stream<CollectRegisterState> _mapGetCollectionDataState(
      GetCollectionData event) async* {
    yield CollectionDataLoading();
    try {
      String? params = getParams(event);
      Response _response =
          await _collectionRepository.getCollectionsRegister(params: params);
      if (_response.data["message"] != null) {
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

  String getParams(GetCollectionData event) {
    String _params = "?";

    if (event.type != null) {
      if (event.type == "सर्व") {
        _params += "";
      } else {
        _params += "type=${event.type}&";
      }
    }
    if (event.psId != null) {
      _params += "psid=${event.psId}&";
    }
    if (event.ppId != null) {
      _params += "ppid=${event.ppId}&";
    }
    if (event.fromDate != null && event.fromDate != "") {
      _params += "fromdate=${event.fromDate}&";
    }
    if (event.toDate != null && event.toDate != "") {
      _params += "todate=${event.toDate}&";
    }
    return _params;
  }
}
