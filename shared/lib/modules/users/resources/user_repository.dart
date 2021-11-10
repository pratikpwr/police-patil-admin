import 'package:api_sdk/api_sdk.dart';
import 'package:dio/dio.dart';

class UsersRepository {
  Future<dynamic> getPPUsers() async {
    final response = await ApiSdk.getPP();
    return response;
  }

  Future<dynamic> updateUserData(int id, Map<String, dynamic> _body) async {
    _body['_method'] = 'put';
    FormData _formData = FormData.fromMap(_body);
    final response = await ApiSdk.updateUserData(userId: id, body: _formData);
    return response;
  }

  Future<dynamic> getPSUsers() async {
    final response = await ApiSdk.getPSUsers();
    return response;
  }

  Future<dynamic> addUser(Map<String, dynamic> user) async {
    final response = await ApiSdk.addUser(body: user);
    return response;
  }
}
