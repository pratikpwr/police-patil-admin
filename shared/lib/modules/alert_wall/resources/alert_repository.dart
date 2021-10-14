import 'package:api_sdk/api_sdk.dart';
import 'package:shared/modules/news/models/news_model.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class AlertRepository {
  Future<dynamic> getAlerts() async {
    final response = await ApiSdk.getAlerts();
    return response;
  }

  Future<dynamic> addAlertData({required AlertData alertData}) async {
    Map<String, dynamic> _body = alertData.toJson();
    _body['file'] = await MultipartFile.fromFile(_body['file']);
    _body['photo'] = await MultipartFile.fromFile(_body['photo']);
    FormData _formData = FormData.fromMap(_body);
    final response = await ApiSdk.postAlerts(body: _formData);
    return response;
  }
}
