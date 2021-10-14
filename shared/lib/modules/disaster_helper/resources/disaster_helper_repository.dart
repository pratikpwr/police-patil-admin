import 'package:api_sdk/api_sdk.dart';
class DisasterHelperRepository {
  Future<dynamic> getDisasterHelper() async {
    final response = await ApiSdk.getDisasterHelper();
    return response;
  }
}
