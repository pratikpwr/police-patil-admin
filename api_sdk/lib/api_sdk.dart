library api_sdk;

import 'package:api_sdk/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:api_sdk/rest/rest_api_handler_data.dart';

class ApiSdk {
  // AUTH

  // static Future<Response> signUp({required String mobileNo}) async {
  //   // sends OTP
  //   String path = '${ApiConstants.SEND_OTP}' + mobileNo;
  //   Response response = await RestApiHandlerData.getData(path);
  //   return response;
  // }

  static Future<Response> loginWithEmailAndPassword(
      {required userAuthData}) async {
    String path = ApiConstants.LOGIN;

    Map<String, dynamic> body = userAuthData;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getUserData({required int userId}) async {
    String path = ApiConstants.GET_USER_DATA + "$userId";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getPP() async {
    String path = ApiConstants.GET_PP;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getPSUsers() async {
    String path = ApiConstants.GET_PS_USERS;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> addUser({required Map<String, dynamic> body}) async {
    String path = ApiConstants.ADD_USER;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getPoliceStation() async {
    String path = ApiConstants.POLICE_STATION_NAME;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getVillages() async {
    String path = ApiConstants.VILLAGE_LIST;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> addPoliceStationName(
      {required Map<String, dynamic> body}) async {
    String path = ApiConstants.POLICE_STATION_NAME;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> updateUserData(
      {required int userId, required dynamic body}) async {
    String path = ApiConstants.UPDATE_USER_DATA + "$userId";

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getTopPP() async {
    String path = ApiConstants.TOP_PP;
    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  // ARMS Register
  static Future<Response> postArmsRegister({required body}) async {
    String path = ApiConstants.ARMS;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getArmsByPP({required int userId}) async {
    String path = ApiConstants.ARMS;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getArms({String? params}) async {
    String path = "${ApiConstants.ARMS}${params ?? ""}";
    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  // Collect Register
  static Future<Response> postCollectRegister({required dynamic body}) async {
    String path = ApiConstants.POST_COLLECT_BY_PP;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getCollectByPP({required int userId}) async {
    String path = ApiConstants.GET_COLLECT_BY_PP + "$userId";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getCollect({String? params}) async {
    String path = "${ApiConstants.GET_COLLECT}${params ?? ""}";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  // Movement Register
  static Future<Response> postMovementRegister({required body}) async {
    String path = ApiConstants.MOVEMENT;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getMovementByPP({required int userId}) async {
    String path = ApiConstants.MOVEMENT + "$userId";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getMovement({String? params}) async {
    String path = "${ApiConstants.MOVEMENT}${params ?? ""}";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getLatestMovement() async {
    String path = ApiConstants.LATEST_MOVEMENT;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  //  Register
  static Future<Response> postWatchRegister({required body}) async {
    String path = ApiConstants.POST_WATCH_BY_PP;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getWatchByPP({required int userId}) async {
    String path = ApiConstants.GET_WATCH_BY_PP + "$userId";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getWatch({String? params}) async {
    String path = "${ApiConstants.GET_WATCH}${params ?? ""}";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getLatestWatch() async {
    String path = ApiConstants.LATEST_WATCH;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  //  Register
  static Future<Response> postCrimeRegister({required body}) async {
    String path = ApiConstants.POST_CRIME_BY_PP;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getCrimeByPP({required int userId}) async {
    String path = ApiConstants.GET_CRIME_BY_PP + "$userId";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getCrime({String? params}) async {
    String path = "${ApiConstants.GET_CRIME}${params ?? ""}";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  //  Register
  static Future<Response> postFireRegister({required body}) async {
    String path = ApiConstants.POST_FIRE_BY_PP;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getFireByPP({required int userId}) async {
    String path = ApiConstants.GET_FIRE_BY_PP + "$userId";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getFire({String? params}) async {
    String path = "${ApiConstants.GET_FIRE}${params ?? ""}";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  //  Register
  static Future<Response> postDeathRegister({required body}) async {
    String path = ApiConstants.POST_DEATH_BY_PP;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getDeathByPP({required int userId}) async {
    String path = ApiConstants.GET_DEATH_BY_PP + "$userId";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getDeath({String? params}) async {
    String path = "${ApiConstants.GET_DEATH}${params ?? ""}";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  //  Register
  static Future<Response> postMissingRegister({required body}) async {
    String path = ApiConstants.POST_MISSING_BY_PP;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getMissingByPP({required int userId}) async {
    String path = ApiConstants.GET_MISSING_BY_PP + "$userId";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getMissing({String? params}) async {
    String path = "${ApiConstants.GET_MISSING}${params ?? ""}";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  //  Register
  static Future<Response> postPlaceRegister({required body}) async {
    String path = ApiConstants.POST_PUBLIC_PLACE_BY_PP;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getPlaceByPP({required int userId}) async {
    String path = ApiConstants.GET_PUBLIC_PLACE_BY_PP + "$userId";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getPlace({String? params}) async {
    String path = "${ApiConstants.GET_PUBLIC_PLACE}${params ?? ""}";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  //  Register
  static Future<Response> postIllegalRegister({required body}) async {
    String path = ApiConstants.POST_ILLEGAL_WORK_BY_PP;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getIllegalByPP({required int userId}) async {
    String path = ApiConstants.GET_ILLEGAL_WORK_BY_PP + "$userId";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getIllegal({String? params}) async {
    String path = "${ApiConstants.GET_ILLEGAL_WORK}${params ?? ""}";

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getLatestIllegal() async {
    String path = ApiConstants.LATEST_ILLEGAL;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getNews() async {
    String path = ApiConstants.GET_NEWS;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getTopNews() async {
    String path = ApiConstants.TOP_NEWS;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> postNews({required body}) async {
    String path = ApiConstants.POST_NEWS;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getAlerts() async {
    String path = ApiConstants.GET_ALERTS;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> postAlerts({required body}) async {
    String path = ApiConstants.POST_ALERTS;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> postDisasterHelper({required body}) async {
    String path = ApiConstants.POST_DISASTER_HELPER;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }

  static Future<Response> getDisasterHelper() async {
    String path = ApiConstants.GET_DISASTER_HELPER;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getDisasterTools() async {
    String path = ApiConstants.GET_DISASTER_TOOLS;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getDisaster() async {
    String path = ApiConstants.GET_DISASTER;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> getKayade() async {
    String path = ApiConstants.KAYADE;

    Response response = await RestApiHandlerData.getData(path);
    return response;
  }

  static Future<Response> postRules({required body}) async {
    String path = ApiConstants.KAYADE;

    Response response = await RestApiHandlerData.postData(path, body);
    return response;
  }
}
