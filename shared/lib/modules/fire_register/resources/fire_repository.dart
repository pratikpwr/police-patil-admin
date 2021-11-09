import 'package:api_sdk/api_sdk.dart';
import 'package:shared/modules/fire_register/models/fire_model.dart';
import 'package:dio/dio.dart';

class FireRepository {
  Future<dynamic> getFireRegisterByPP({required int userId}) async {
    final response = await ApiSdk.getFireByPP(userId: userId);
    return response;
  }

  Future<dynamic> getFireRegister({String? params}) async {
    final response = await ApiSdk.getFire(params: params);
    return response;
  }

  Future<dynamic> addFireData({required FireData fireData}) async {
    Map<String, dynamic> _body = fireData.toJson();
    _body['photo'] = await MultipartFile.fromFile(_body['photo']);
    FormData _formData = FormData.fromMap(_body);
    final response = await ApiSdk.postFireRegister(body: _formData);
    return response;
  }
}
