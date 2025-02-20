import 'dart:convert';

MachineCategoriesModel machineCategoriesModelFromJson(String str) =>
    MachineCategoriesModel.fromJson(json.decode(str));

String machineCategoriesModelToJson(MachineCategoriesModel data) =>
    json.encode(data.toJson());

class MachineCategoriesModel {
  String status;
  String message;
  List<Detail> details;

  MachineCategoriesModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory MachineCategoriesModel.fromJson(Map<String, dynamic> json) =>
      MachineCategoriesModel(
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
  String mainCatId;
  String name;
  String isActive;
  DateTime createdAt;

  Detail({
    required this.id,
    required this.mainCatId,
    required this.name,
    required this.isActive,
    required this.createdAt,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        mainCatId: json["main_cat_id"],
        name: json["name"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "main_cat_id": mainCatId,
        "name": name,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
      };
}
