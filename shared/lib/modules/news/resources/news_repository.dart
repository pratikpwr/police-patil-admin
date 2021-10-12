import 'package:api_sdk/api_sdk.dart';

class NewsRepository {
  Future<dynamic> getNews() async {
    final response = await ApiSdk.getNews();
    return response;
  }
}
