import 'package:shared/shared.dart';

class HomeData {
  List<UserClass>? topPP;
  List<IllegalData>? latestIllegal;
  List<WatchData>? latestWatch;
  List<MovementData>? latestMovement;

  HomeData(
      {this.topPP, this.latestIllegal, this.latestWatch, this.latestMovement});
}
