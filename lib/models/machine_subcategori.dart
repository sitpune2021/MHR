import 'dart:convert';

MachineSubCategoriesModel machineSubCategoriesModelFromJson(String str) =>
    MachineSubCategoriesModel.fromJson(json.decode(str));

String machineSubCategoriesModelToJson(MachineSubCategoriesModel data) =>
    json.encode(data.toJson());

class MachineSubCategoriesModel {
  String status;
  String message;
  List<Detail> details;

  MachineSubCategoriesModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory MachineSubCategoriesModel.fromJson(Map<String, dynamic> json) =>
      MachineSubCategoriesModel(
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
  dynamic machinePurchasePrice;
  dynamic machineLife;
  dynamic salvageValue;
  dynamic powerCost;
  dynamic operatorWage;
  dynamic consumableCost;
  dynamic factoryRent;
  dynamic operatingHours;
  dynamic workingDays;
  String isActive;
  DateTime createdAt;

  Detail({
    required this.id,
    required this.catId,
    required this.name,
    required this.machinePurchasePrice,
    required this.machineLife,
    required this.salvageValue,
    required this.powerCost,
    required this.operatorWage,
    required this.consumableCost,
    required this.factoryRent,
    required this.operatingHours,
    required this.workingDays,
    required this.isActive,
    required this.createdAt,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        catId: json["cat_id"],
        name: json["name"],
        machinePurchasePrice: json["machine_purchase_price"],
        machineLife: json["machine_life"],
        salvageValue: json["salvage_value"],
        powerCost: json["power_cost"],
        operatorWage: json["operator_wage"],
        consumableCost: json["consumable_cost"],
        factoryRent: json["factory_rent"],
        operatingHours: json["operating_hours"],
        workingDays: json["working_days"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cat_id": catId,
        "name": name,
        "machine_purchase_price": machinePurchasePrice,
        "machine_life": machineLife,
        "salvage_value": salvageValue,
        "power_cost": powerCost,
        "operator_wage": operatorWage,
        "consumable_cost": consumableCost,
        "factory_rent": factoryRent,
        "operating_hours": operatingHours,
        "working_days": workingDays,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
      };
}
