class ArmsResponse {
  ArmsResponse({
    this.message,
    this.data,
  });

  String? message;
  List<ArmsData>? data;

  factory ArmsResponse.fromJson(Map<String, dynamic> json) => ArmsResponse(
        message: json["message"],
        data:
            List<ArmsData>.from(json["data"].map((x) => ArmsData.fromJson(x))),
      );
}

class ArmsData {
  ArmsData({
    this.id,
    this.type,
    this.name,
    this.mobile,
    this.aadhar,
    this.address,
    this.latitude,
    this.longitude,
    this.licenceNumber,
    this.uid,
    this.weaponCondition,
    this.validity,
    this.licencephoto,
    this.ppid,
    this.psid,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? type;
  String? name;
  int? mobile;
  String? aadhar;
  String? address;
  double? latitude;
  double? longitude;
  String? licenceNumber;
  String? uid;
  String? weaponCondition;
  DateTime? validity;
  String? licencephoto;
  int? ppid;
  int? psid;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ArmsData.fromJson(Map<String, dynamic> json) => ArmsData(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        mobile: json["mobile"],
        aadhar: json["aadhar"],
        address: json["address"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        licenceNumber: json["licencenumber"],
        uid: json["uid"],
        weaponCondition: json["weapon_condition"],
        validity:
            json["validity"] == null ? null : DateTime.parse(json["validity"]),
        licencephoto: json["licencephoto"],
        ppid: json["ppid"],
        psid: json["psid"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "mobile": mobile,
        "aadhar": aadhar,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "licencenumber": licenceNumber,
        "uid": uid,
        "weapon_condition": weaponCondition,
        "validity": validity!.toIso8601String(),
        "licencephoto": licencephoto,
        "ppid": ppid,
        "psid": psid,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
