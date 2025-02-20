import 'dart:convert';

MachineCalculationModel machineCalculationModelFromJson(String str) =>
    MachineCalculationModel.fromJson(json.decode(str));

String machineCalculationModelToJson(MachineCalculationModel data) =>
    json.encode(data.toJson());

class MachineCalculationModel {
  String status;
  String message;
  Data data;

  MachineCalculationModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MachineCalculationModel.fromJson(Map<String, dynamic> json) =>
      MachineCalculationModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String depreciation;
  String powerCost;
  String operatorWages;
  String totalCostPerYear;
  String totalWorkingHours;
  String mhr;

  Data({
    required this.depreciation,
    required this.powerCost,
    required this.operatorWages,
    required this.totalCostPerYear,
    required this.totalWorkingHours,
    required this.mhr,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        depreciation: json["Depreciation"],
        powerCost: json["Power Cost"],
        operatorWages: json["Operator Wages"],
        totalCostPerYear: json["Total Cost Per Year"],
        totalWorkingHours: json["Total Working Hours"],
        mhr: json["MHR"],
      );

  Map<String, dynamic> toJson() => {
        "Depreciation": depreciation,
        "Power Cost": powerCost,
        "Operator Wages": operatorWages,
        "Total Cost Per Year": totalCostPerYear,
        "Total Working Hours": totalWorkingHours,
        "MHR": mhr,
      };
}
