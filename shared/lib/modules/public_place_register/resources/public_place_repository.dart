import 'package:api_sdk/api_sdk.dart';
import 'package:shared/modules/public_place_register/models/public_place_model.dart';
import 'package:dio/dio.dart';

class PlaceRepository {
  Future<dynamic> getPlaceRegisterByPP({required int userId}) async {
    final response = await ApiSdk.getPlaceByPP(userId: userId);
    return response;
  }

  Future<dynamic> getPlaceRegister({String? params}) async {
    final response = await ApiSdk.getPlace(params: params);
    return response;
  }

  Future<dynamic> addPlaceData({required PlaceData placeData}) async {
    Map<String, dynamic> _body = placeData.toJson();
    _body['photo'] = await MultipartFile.fromFile(_body['photo']);
    FormData _formData = FormData.fromMap(_body);
    final response = await ApiSdk.postPlaceRegister(body: _formData);
    return response;
  }
}
