import 'dart:convert';

MachineCategoriModel machineCategoriModelFromJson(String str) =>
    MachineCategoriModel.fromJson(json.decode(str));

String machineCategoriModelToJson(MachineCategoriModel data) =>
    json.encode(data.toJson());

class MachineCategoriModel {
  String status;
  String message;
  List<Detail> details;

  MachineCategoriModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory MachineCategoriModel.fromJson(Map<String, dynamic> json) =>
      MachineCategoriModel(
        status: json["status"],
        message: json["message"],
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class Detail {
  String id;
  String name;
  String isdeleted;
  DateTime createdAt;

  Detail({
    required this.id,
    required this.name,
    required this.isdeleted,
    required this.createdAt,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        name: json["name"],
        isdeleted: json["isdeleted"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isdeleted": isdeleted,
        "created_at": createdAt.toIso8601String(),
      };
}
