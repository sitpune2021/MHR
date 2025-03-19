// ignore_for_file: file_names
import 'dart:convert';

CalculationModel calculationModelFromJson(String str) =>
    CalculationModel.fromJson(json.decode(str));

String calculationModelToJson(CalculationModel data) =>
    json.encode(data.toJson());

class CalculationModel {
  String? depreciation;
  String? powerCost;
  String? operatorWages;
  String? totalCostPerYear;
  String? totalWorkingHours;
  String? mhr;
  String? currencyName;

  CalculationModel({
    required this.depreciation,
    required this.powerCost,
    required this.operatorWages,
    required this.totalCostPerYear,
    required this.totalWorkingHours,
    required this.mhr,
    required this.currencyName,
  });

  factory CalculationModel.fromJson(Map<String, dynamic> json) =>
      CalculationModel(
        depreciation: json["Depreciation"],
        powerCost: json["Power Cost"],
        operatorWages: json["Operator Wages"],
        totalCostPerYear: json["Total Cost Per Year"],
        totalWorkingHours: json["Total Working Hours"],
        mhr: json["MHR"],
        currencyName: json["Currency Name"],
      );

  Map<String, dynamic> toJson() => {
        "Depreciation": depreciation,
        "Power Cost": powerCost,
        "Operator Wages": operatorWages,
        "Total Cost Per Year": totalCostPerYear,
        "Total Working Hours": totalWorkingHours,
        "MHR": mhr,
        "Currency Name": currencyName,
      };
}
