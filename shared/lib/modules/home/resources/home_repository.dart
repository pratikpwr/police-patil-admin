import 'package:api_sdk/api_sdk.dart';

class HomeRepository {
  Future<dynamic> getHomeData({String? params}) async {
    final response = await ApiSdk.getHomeData(params: params);
    return response;
  }

  Future<dynamic> getLatestIllegal() async {
    final response = await ApiSdk.getLatestIllegal();
    return response;
  }

  Future<dynamic> getLatestWatch() async {
    final response = await ApiSdk.getLatestWatch();
    return response;
  }

  Future<dynamic> getLatestMovement() async {
    final response = await ApiSdk.getLatestMovement();
    return response;
  }

  Future<dynamic> getTopPP() async {
    final response = await ApiSdk.getTopPP();
    return response;
  }
}
