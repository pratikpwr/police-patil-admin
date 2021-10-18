import 'package:shared/modules/authentication/models/user.dart';

class UsersResponse {
  UsersResponse({
    this.message,
    this.data,
  });

  String? message;
  List<UserClass>? data;

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        message: json["message"],
        data: List<UserClass>.from(
            json["data"].map((x) => UserClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
