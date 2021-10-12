import 'package:api_sdk/api_sdk.dart';

class AuthenticationRepository {
  Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    var data = {'email': email, 'password': password};
    final response = await ApiSdk.loginWithEmailAndPassword(userAuthData: data);

    return response;
  }
}
