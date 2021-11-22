// ignore_for_file: constant_identifier_names

class ApiConstants {
  static const String BASE_URL = 'https://pp.thesupernest.com';

  // static const String BASE_URL = "localhost:1337";

  // Methods
  static const String LOGIN = BASE_URL + '/api/user/login';
  static const String GET_USER_DATA = BASE_URL + '/api/user/';
  static const String UPDATE_USER_DATA = BASE_URL + '/api/user/';

  static const String GET_USERS = BASE_URL + '/api/user';
  static const String GET_PP = BASE_URL + '/api/pp';
  static const String GET_PS_USERS = BASE_URL + '/api/ps';
  static const String ADD_USER = BASE_URL + '/api/adduser';

  static const String POLICE_STATION_NAME = BASE_URL + '/api/policestation';
  static const String VILLAGE_LIST = BASE_URL + "/api/village";

  //
  static const String TOP_PP = BASE_URL + '/api/top-pp';
  static const String LATEST_ILLEGAL = BASE_URL + '/api/latestillegalwork';
  static const String LATEST_WATCH = BASE_URL + '/api/latestwatch';
  static const String LATEST_MOVEMENT = BASE_URL + '/api/latestmovement';

  static const String ARMS = BASE_URL + '/api/arms';

  static const String MOVEMENT = BASE_URL + '/api/movement';

  static const String GET_COLLECT_BY_PP = BASE_URL + '/api/seize/showbyppid/';
  static const String GET_COLLECT = BASE_URL + '/api/seize';
  static const String POST_COLLECT_BY_PP = BASE_URL + '/api/seize';

  static const String GET_WATCH_BY_PP = BASE_URL + '/api/watch/showbyppid/';
  static const String GET_WATCH = BASE_URL + '/api/watch';
  static const String POST_WATCH_BY_PP = BASE_URL + '/api/watch';

  static const String GET_CRIME_BY_PP = BASE_URL + '/api/crime/showbyppid/';
  static const String GET_CRIME = BASE_URL + '/api/crime';
  static const String POST_CRIME_BY_PP = BASE_URL + '/api/crime';

  static const String GET_FIRE_BY_PP = BASE_URL + '/api/fire/showbyppid/';
  static const String GET_FIRE = BASE_URL + '/api/fire';
  static const String POST_FIRE_BY_PP = BASE_URL + '/api/fire ';

  static const String GET_DEATH_BY_PP = BASE_URL + '/api/death/showbyppid/';
  static const String GET_DEATH = BASE_URL + '/api/death';
  static const String POST_DEATH_BY_PP = BASE_URL + '/api/death';

  static const String GET_MISSING_BY_PP = BASE_URL + '/api/missing/showbyppid/';
  static const String GET_MISSING = BASE_URL + '/api/missing';
  static const String POST_MISSING_BY_PP = BASE_URL + '/api/missing';

  static const String GET_PUBLIC_PLACE_BY_PP =
      BASE_URL + '/api/publicplace/showbyppid/';
  static const String GET_PUBLIC_PLACE = BASE_URL + '/api/publicplace';
  static const String POST_PUBLIC_PLACE_BY_PP = BASE_URL + '/api/publicplace';

  static const String GET_ILLEGAL_WORK_BY_PP =
      BASE_URL + '/api/illegalwork/showbyppid/';
  static const String GET_ILLEGAL_WORK = BASE_URL + '/api/illegalwork';
  static const String POST_ILLEGAL_WORK_BY_PP = BASE_URL + '/api/illegalwork';

  static const String GET_NEWS = BASE_URL + "/api/news";
  static const String TOP_NEWS = BASE_URL + "/api/topnews";
  static const String POST_NEWS = BASE_URL + "/api/news";

  static const String GET_ALERTS = BASE_URL + "/api/alert";
  static const String POST_ALERTS = BASE_URL + "/api/alert";

  static const String GET_DISASTER_HELPER_BY_PP =
      BASE_URL + "/api/disasterhelper/showbyppid/";
  static const String POST_DISASTER_HELPER = BASE_URL + "/api/disasterhelper";
  static const String GET_DISASTER_HELPER = BASE_URL + "/api/disasterhelper";

  static const String GET_DISASTER_TOOLS_BY_PP =
      BASE_URL + "/api/disastertools/showbyppid/";
  static const String POST_DISASTER_TOOLS = BASE_URL + "/api/disastertools";
  static const String GET_DISASTER_TOOLS = BASE_URL + "/api/disastertools";

  static const String GET_DISASTERS_BY_PP =
      BASE_URL + "/api/disaster/showbyppid/";
  static const String POST_DISASTER = BASE_URL + "/api/disaster";
  static const String GET_DISASTER = BASE_URL + "/api/disaster";

  static const String KAYADE = BASE_URL + "/api/kayade";
  static const String HOME_DATA = BASE_URL + "/api/home";

  static const String POST_APP_VERSION = BASE_URL + "/api";
}
