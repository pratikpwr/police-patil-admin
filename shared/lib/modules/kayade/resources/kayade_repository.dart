import 'package:api_sdk/api_sdk.dart';
import 'package:dio/dio.dart';
import '../../../shared.dart';

class KayadeRepository {
  Future<dynamic> getKayade() async {
    final response = await ApiSdk.getKayade();
    return response;
  }

  Future<dynamic> addKayadeData({required Map<String, dynamic> body}) async {
    // Map<String, dynamic> body = kayadeData.toJson();
    body['file'] = MultipartFile.fromBytes(body['file']);
    FormData _formData = FormData.fromMap(body);
    final response = await ApiSdk.postRules(body: _formData);
    return response;
  }
}
