// ignore_for_file: file_names
import 'dart:convert';

CalculationListModel calculationListModelFromJson(String str) =>
    CalculationListModel.fromJson(json.decode(str));

String calculationListModelToJson(CalculationListModel data) =>
    json.encode(data.toJson());

class CalculationListModel {
  String? id;
  String? userId;
  String? mainCatId;
  String? currencyId;
  String? currencyAmount;
  String? subcatId;
  String? powerConsumption; //
  String? maintananceCost;
  String? machinePurchasePrice;
  String? machineLife;
  String? salvageValue;
  String? powerCostPerUnit; //
  String? operatorWage;
  String? consumableCost;
  String? factoryRent;
  String? operatingHours;
  String? workingDays;
  String? depreciation;
  String? powerCost;
  String? operatorWages;
  String? totalCostPerYear;
  String? totalWorkingHours;
  String? fuelCostPerHour;
  String? machineHourRate;

  CalculationListModel({
    required this.id,
    required this.userId,
    required this.mainCatId,
    required this.currencyId,
    required this.currencyAmount,
    required this.subcatId,
    required this.powerConsumption,
    required this.maintananceCost,
    required this.machinePurchasePrice,
    required this.machineLife,
    required this.salvageValue,
    required this.powerCostPerUnit,
    required this.operatorWage,
    required this.consumableCost,
    required this.factoryRent,
    required this.operatingHours,
    required this.workingDays,
    required this.depreciation,
    required this.powerCost,
    required this.operatorWages,
    required this.totalCostPerYear,
    required this.totalWorkingHours,
    required this.fuelCostPerHour,
    required this.machineHourRate,
  });

  factory CalculationListModel.fromJson(Map<String, dynamic> json) =>
      CalculationListModel(
        id: json["id"],
        userId: json["user_id"],
        mainCatId: json["main_cat_id"],
        currencyId: json["currency_id"],
        currencyAmount: json["currency_amount"],
        subcatId: json["subcat_id"],
        powerConsumption: json["power_consumption"],
        maintananceCost: json["maintanance_cost"],
        machinePurchasePrice: json["machine_purchase_price"],
        machineLife: json["machine_life"],
        salvageValue: json["salvage_value"],
        powerCostPerUnit: json["power_cost_per_unit"],
        operatorWage: json["operator_wage"],
        consumableCost: json["consumable_cost"],
        factoryRent: json["factory_rent"],
        operatingHours: json["operating_hours"],
        workingDays: json["working_days"],
        depreciation: json["depreciation"],
        powerCost: json["power_cost"],
        operatorWages: json["operator_wages"],
        totalCostPerYear: json["total_cost_per_year"],
        totalWorkingHours: json["total_working_hours"],
        fuelCostPerHour: json["fuel_cost_per_hour"],
        machineHourRate: json["machine_hour_rate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "main_cat_id": mainCatId,
        "currency_id": currencyId,
        "currency_amount": currencyAmount,
        "subcat_id": subcatId,
        "power_consumption": powerConsumption,
        "maintanance_cost": maintananceCost,
        "machine_purchase_price": machinePurchasePrice,
        "machine_life": machineLife,
        "salvage_value": salvageValue,
        "power_cost_per_unit": powerCostPerUnit,
        "operator_wage": operatorWage,
        "consumable_cost": consumableCost,
        "factory_rent": factoryRent,
        "operating_hours": operatingHours,
        "working_days": workingDays,
        "depreciation": depreciation,
        "power_cost": powerCost,
        "operator_wages": operatorWages,
        "total_cost_per_year": totalCostPerYear,
        "total_working_hours": totalWorkingHours,
        "fuel_cost_per_hour": fuelCostPerHour,
        "machine_hour_rate": machineHourRate,
      };
}
