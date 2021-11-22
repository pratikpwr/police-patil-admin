import 'package:shared/shared.dart';

class HomeResponse {
  HomeResponse({
    required this.message,
    required this.data,
  });

  String message;
  HomeData data;

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
        message: json["message"],
        data: HomeData.fromJson(json["data"]),
      );
}

class HomeData {
  HomeData({
    this.topPP,
    this.latestIllegal,
    this.latestWatch,
    this.latestMovement,
    required this.graphCrime,
    required this.graphMovement,
  });

  List<UserClass>? topPP;
  List<IllegalData>? latestIllegal;
  List<WatchData>? latestWatch;
  List<MovementData>? latestMovement;
  List<GraphPoint> graphCrime;
  List<GraphPoint> graphMovement;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        topPP: List<UserClass>.from(
            json["top10pp"].map((x) => UserClass.fromJson(x))),
        latestIllegal: List<IllegalData>.from(
            json["latestillegalwork"].map((x) => IllegalData.fromJson(x))),
        latestWatch: List<WatchData>.from(
            json["latestwatch"].map((x) => WatchData.fromJson(x))),
        latestMovement: List<MovementData>.from(
            json["latestmovement"].map((x) => MovementData.fromJson(x))),
        graphCrime: List<GraphPoint>.from(
            json["graphcrime"].map((x) => GraphPoint.fromJson(x))),
        graphMovement: List<GraphPoint>.from(
            json["graphmovement"].map((x) => GraphPoint.fromJson(x))),
      );
}

class GraphPoint {
  GraphPoint({
    required this.count,
    required this.monthName,
  });

  int count;
  String monthName;

  factory GraphPoint.fromJson(Map<String, dynamic> json) => GraphPoint(
        count: json["count"],
        monthName: json["month_name"],
      );
}
