// ignore_for_file: file_names
import 'dart:convert';

List<MainMachineModel> mainMachineModelFromJson(String str) =>
    List<MainMachineModel>.from(
        json.decode(str).map((x) => MainMachineModel.fromJson(x)));

String mainMachineModelToJson(List<MainMachineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MainMachineModel {
  String id;
  String name;

  MainMachineModel({
    required this.id,
    required this.name,
  });

  factory MainMachineModel.fromJson(Map<String, dynamic> json) =>
      MainMachineModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
