import 'package:api_sdk/api_sdk.dart';
import 'package:shared/modules/police_station/police_station.dart';

class PoliceStationRepository {
  Future<dynamic> getPoliceStations() async {
    final response = await ApiSdk.getAdminPS();
    return response;
  }

  Future<dynamic> addPoliceStation(PoliceStationData psData) async {
    final body = psData.toJson();
    final response = await ApiSdk.addPoliceStation(body: body);
    return response;
  }
}
