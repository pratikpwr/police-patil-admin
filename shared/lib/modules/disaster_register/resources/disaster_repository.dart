import 'package:api_sdk/api_sdk.dart';
import 'package:shared/modules/disaster_register/models/disaster_model.dart';

class DisasterRepository {
  Future<dynamic> getDisasterRegister() async {
    final response = await ApiSdk.getDisaster();
    return response;
  }
}
