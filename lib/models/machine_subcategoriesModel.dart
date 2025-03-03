// ignore_for_file: file_names
import 'dart:convert';

MachineSubCatModel machineSubCatModelFromJson(String str) =>
    MachineSubCatModel.fromJson(json.decode(str));

String machineSubCatModelToJson(MachineSubCatModel data) =>
    json.encode(data.toJson());

class MachineSubCatModel {
  String id;
  String catId;
  String name;

  MachineSubCatModel({
    required this.id,
    required this.catId,
    required this.name,
  });

  factory MachineSubCatModel.fromJson(Map<String, dynamic> json) =>
      MachineSubCatModel(
        id: json["id"],
        catId: json["cat_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cat_id": catId,
        "name": name,
      };
}
