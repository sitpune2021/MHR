// ignore_for_file: file_names
import 'dart:convert';

List<MachineCatModel> machineCatModelFromJson(String str) =>
    List<MachineCatModel>.from(
        json.decode(str).map((x) => MachineCatModel.fromJson(x)));

String machineCatModelToJson(List<MachineCatModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MachineCatModel {
  String id;
  String mainCatId;
  String name;

  MachineCatModel({
    required this.id,
    required this.mainCatId,
    required this.name,
  });

  factory MachineCatModel.fromJson(Map<String, dynamic> json) =>
      MachineCatModel(
        id: json["id"],
        mainCatId: json["main_cat_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "main_cat_id": mainCatId,
        "name": name,
      };
}
