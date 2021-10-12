import 'package:api_sdk/api_sdk.dart';

class KayadeRepository {
  Future<dynamic> getKayade() async {
    final response = await ApiSdk.getKayade();
    return response;
  }
}
