import 'package:api_sdk/api_sdk.dart';

class AlertRepository {
  Future<dynamic> getAlerts() async {
    final response = await ApiSdk.getAlerts();
    return response;
  }
}
