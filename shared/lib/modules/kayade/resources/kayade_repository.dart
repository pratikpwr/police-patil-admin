import 'package:api_sdk/api_sdk.dart';
import 'package:dio/dio.dart';
import '../../../shared.dart';

class KayadeRepository {
  Future<dynamic> getKayade() async {
    final response = await ApiSdk.getKayade();
    return response;
  }

  Future<dynamic> addKayadeData({required KayadeData kayadeData}) async {
    Map<String, dynamic> _body = kayadeData.toJson();
    _body['file'] = await MultipartFile.fromFile(_body['file']);
    FormData _formData = FormData.fromMap(_body);
    final response = await ApiSdk.postAlerts(body: _formData);
    return response;
  }
}
