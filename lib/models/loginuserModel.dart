// ignore_for_file: file_names

import 'dart:convert';

LoginUserModel loginUserModelFromJson(String str) =>
    LoginUserModel.fromJson(json.decode(str));

String loginUserModelToJson(LoginUserModel data) => json.encode(data.toJson());

class LoginUserModel {
  String status;
  String message;
  Details details;

  LoginUserModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) => LoginUserModel(
        status: json["status"],
        message: json["message"],
        details: Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "details": details.toJson(),
      };
}

class Details {
  String id;
  String name;
  String mobile;
  String email;
  String username;
  dynamic password;
  String otp;
  String userType;
  String isdeleted;
  DateTime createdAt;

  Details({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.username,
    required this.password,
    required this.otp,
    required this.userType,
    required this.isdeleted,
    required this.createdAt,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        otp: json["otp"],
        userType: json["user_type"],
        isdeleted: json["isdeleted"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "email": email,
        "username": username,
        "password": password,
        "otp": otp,
        "user_type": userType,
        "isdeleted": isdeleted,
        "created_at": createdAt.toIso8601String(),
      };
}
