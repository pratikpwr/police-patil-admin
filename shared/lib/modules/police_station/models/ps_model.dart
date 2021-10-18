class PoliceStationResponse {
  PoliceStationResponse({
    this.message,
    this.data,
  });

  String? message;
  List<PoliceStationData>? data;

  factory PoliceStationResponse.fromJson(Map<String, dynamic> json) =>
      PoliceStationResponse(
        message: json["message"],
        data: List<PoliceStationData>.from(
            json["data"].map((x) => PoliceStationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PoliceStationData {
  PoliceStationData({
    this.id,
    this.psname,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? psname;
  String? email;
  String? address;
  double? latitude;
  double? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PoliceStationData.fromJson(Map<String, dynamic> json) =>
      PoliceStationData(
        id: json["id"],
        psname: json["psname"],
        email: json["email"],
        address: json["address"],
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"] ?? '2021-03-21'),
      );

  Map<String, dynamic> toJson() => {
        "psname": psname,
        "email": email,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}
