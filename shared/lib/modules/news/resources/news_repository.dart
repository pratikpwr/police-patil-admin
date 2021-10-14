import 'package:api_sdk/api_sdk.dart';
import 'package:shared/shared.dart';
import 'package:dio/dio.dart';
class NewsRepository {
  Future<dynamic> getNews() async {
    final response = await ApiSdk.getNews();
    return response;
  }
  Future<dynamic> addNewsData({required NewsData newsData}) async {
    Map<String, dynamic> _body = newsData.toJson();
    _body['file'] = await MultipartFile.fromFile(_body['file']);
    FormData _formData = FormData.fromMap(_body);
    final response = await ApiSdk.postAlerts(body: _formData);
    return response;
  }
}
