import 'package:api_sdk/api_sdk.dart';
import 'package:shared/modules/disaster_tools/models/tools_model.dart';

class DisasterToolsRepository {
  Future<dynamic> getDisasterToolsRegister() async {
    final response = await ApiSdk.getDisasterTools();
    return response;
  }
}
