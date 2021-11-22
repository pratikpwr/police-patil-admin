import 'package:http/http.dart' as http;
import 'package:api_sdk/api_sdk.dart';
import 'package:dio/dio.dart';

class KayadeRepository {
  Future<dynamic> getKayade() async {
    final response = await ApiSdk.getKayade();
    return response;
  }

  Future<dynamic> addKayadeData({required dynamic body}) async {
    // Map<String, dynamic> body = kayadeData.toJson();
    // body['file'] = http.MultipartFile.fromBytes('file', body['file'],
    //     filename: "file_up");
    // MultipartFile.fromBytes('file',body['file']);
    // FormData _formData = FormData.fromMap(body);
    final response = await ApiSdk.postRules(body: body);
    return response;
  }
}
