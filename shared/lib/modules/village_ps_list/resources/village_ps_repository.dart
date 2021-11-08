import 'package:api_sdk/api_sdk.dart';

class VillagePSListRepository {
  Future<dynamic> getVillageList() async {
    final response = await ApiSdk.getVillages();
    return response;
  }

  Future<dynamic> getPSList() async {
    final response = await ApiSdk.getPoliceStation();
    return response;
  }
}
