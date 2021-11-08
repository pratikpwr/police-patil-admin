import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ppadmin/src/config/constants.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    message,
    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
  )));
}

List<dynamic> typeWiseData(
    {required String? value,
    required List<String> types,
    required List<dynamic> data}) {
  List<dynamic> newData = [];

  for (int i = 0; i < types.length; i++) {
    if (value == types[0]) {
      return data;
    }
    if (value == types[i]) {
      newData.addAll(data.where((element) => element.type == types[i]));
      return newData;
    }
  }
  return data;
}

String? youtubeUrlToId(String? url, {bool trimWhitespaces = true}) {
  if (!url!.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var exp in [
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_COLOR)),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  SomethingWentWrong({Key? key, this.message}) : super(key: key);
  String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message ?? SOMETHING_WENT_WRONG,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class NoRecordFound extends StatelessWidget {
  NoRecordFound({Key? key, this.message}) : super(key: key);
  String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message ?? NO_RECORD,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}

Widget spacer({double? height, double? width}) {
  return SizedBox(
    height: height ?? 16,
    width: width ?? 0,
  );
}

String showDate(DateTime? date) {
  if (date == null) {
    return "-";
  } else {
    return date.toIso8601String().substring(0, 10);
  }
}

int? parseInt(String? string) {
  int? parsedInt;
  try {
    parsedInt = int.parse(string!);
    return parsedInt;
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}

DateTime? parseDate(String? date, {String? form}) {
  DateTime? formattedDate;
  DateFormat format = DateFormat(form ?? "yyyy-MM-dd");
  try {
    formattedDate = format.parse(date!);
    return formattedDate;
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}

List<String> getVillageListInString(List<Village> list) {
  List<String> villageList = [];
  for (var vil in list) {
    villageList.add(vil.village!);
  }
  return villageList;
}

List<String> getPSListInString(List<PoliceStation> list) {
  List<String> villageList = [];
  for (var vil in list) {
    villageList.add(vil.psname!);
  }
  return villageList;
}

String getPsIDFromPSName(List<PoliceStation> psList, String psname) {
  var curVil = psList.firstWhere((element) => element.psname == psname);

  return curVil.id!.toString();
}

String getPpIDFromVillage(List<Village> vilList, String village) {
  var curVil = vilList.firstWhere((element) => element.village == village);

  return curVil.ppid!.toString();
}

// Future<Position> determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return Future.error('Location services are disabled.');
//   }
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return Future.error('Location permissions are denied');
//     }
//   }
//   if (permission == LocationPermission.deniedForever) {
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }
//   return await Geolocator.getCurrentPosition();
// }

void launchUrl(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

String dateInFormat(DateTime dateTime) {
  String date = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  String time = "${dateTime.hour}:${dateTime.minute}";
  return "वेळ: $time आणि तारीख: $date";
}
