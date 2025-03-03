// ignore_for_file: file_names

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? name;
  String? mobile;
  String? email;
  String? username;
  dynamic password;
  dynamic otp;
  String? userType;

  UserModel({
    required this.id,
    this.name,
    required this.mobile,
    this.email,
    required this.username,
    this.password,
    required this.otp,
    this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        otp: json["otp"],
        userType: json["user_type"],
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
      };
}
