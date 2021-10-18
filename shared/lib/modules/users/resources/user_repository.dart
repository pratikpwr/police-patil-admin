import 'package:api_sdk/api_sdk.dart';

class UsersRepository {
  Future<dynamic> getUsers() async {
    final response = await ApiSdk.getUsers();
    return response;
  }

  Future<dynamic> addUser(Map<String, dynamic> user) async {
    final response = await ApiSdk.addUser(body: user);
    return response;
  }
}
