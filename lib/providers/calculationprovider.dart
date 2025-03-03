import 'package:flutter/foundation.dart';
import 'package:machine_hour_rate/core/services/auth_service.dart';
import 'package:machine_hour_rate/models/calculationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculationProvider with ChangeNotifier {
  CalculationModel? calculation;
  bool _isLoading = false;

  CalculationModel? get calculationResult => calculation;
  bool get isLoading => _isLoading;

  Future<void> calculateMHR(Map<String, dynamic> requestBody) async {
    _isLoading = true;
    notifyListeners();

    final service = AuthService();
    try {
      calculation = await service.fetchCalculationData(requestBody);
      if (calculation != null) {
        // Save results to SharedPreferences
        SharedPrefsHelper.saveCalculationResult(calculation!);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error calculating MHR: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Optionally add method to clear results
  void clearCalculationResult() {
    calculation = null;
    notifyListeners();
  }
}

class SharedPrefsHelper {
  static Future<void> saveUserInput(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getUserInput(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveCalculationResult(
      CalculationModel calculation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("depreciation", calculation.depreciation ?? "");
    await prefs.setString("power_costs", calculation.powerCost ?? "");
    await prefs.setString("operator_wages", calculation.operatorWages ?? "");
    await prefs.setString(
        "total_cost_per_year", calculation.totalCostPerYear ?? "");
    await prefs.setString(
        "total_working_hours", calculation.totalWorkingHours ?? "");
    await prefs.setString("mhr", calculation.mhr ?? "");
  }

  static Future<CalculationModel?> getCalculationResult() async {
    final prefs = await SharedPreferences.getInstance();
    return CalculationModel(
      depreciation: prefs.getString("depreciation"),
      powerCost: prefs.getString("power_costs"),
      operatorWages: prefs.getString("operator_wages"),
      totalCostPerYear: prefs.getString("total_cost_per_year"),
      totalWorkingHours: prefs.getString("total_working_hours"),
      mhr: prefs.getString("mhr"),
    );
  }
}
