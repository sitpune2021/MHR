import 'dart:convert';

MachineSubCategoriModel machineSubCategoriModelFromJson(String str) =>
    MachineSubCategoriModel.fromJson(json.decode(str));

String machineSubCategoriModelToJson(MachineSubCategoriModel data) =>
    json.encode(data.toJson());

class MachineSubCategoriModel {
  String status;
  String message;
  List<Detail> details;

  MachineSubCategoriModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory MachineSubCategoriModel.fromJson(Map<String, dynamic> json) =>
      MachineSubCategoriModel(
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
  String catId;
  String name;
  String isdeleted;
  DateTime createdAt;

  Detail({
    required this.id,
    required this.catId,
    required this.name,
    required this.isdeleted,
    required this.createdAt,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        catId: json["cat_id"],
        name: json["name"],
        isdeleted: json["isdeleted"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cat_id": catId,
        "name": name,
        "isdeleted": isdeleted,
        "created_at": createdAt.toIso8601String(),
      };
}
