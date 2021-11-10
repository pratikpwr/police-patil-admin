import 'package:api_sdk/api_sdk.dart';
import 'package:shared/modules/police_station/police_station.dart';

class PoliceStationRepository {
  Future<dynamic> getPoliceStationsName() async {
    final response = await ApiSdk.getPSUsers();
    return response;
  }

  Future<dynamic> addPoliceStationName(PoliceStationData psData) async {
    final body = psData.toJson();
    final response = await ApiSdk.addPoliceStationName(body: body);
    return response;
  }
}
