import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:machine_hour_rate/core/services/auth_service.dart';
import 'package:machine_hour_rate/models/currency,dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, String>? _validationErrors;
  Map<String, String>? get validationErrors => _validationErrors;

  Map<String, dynamic>? _userData;

  // List<CurrencyModel> _currencies = [];
  // List<CurrencyModel> get currencies => _currencies;

  // List<Map<String, dynamic>> _machine = [];
  // List<Map<String, dynamic>> get machine => _machine;

  Future<String?> registerUser({
    required String firstName,
    required String lastName,
    required String mobile,
    String? email,
  }) async {
    _isLoading = true;
    _validationErrors = null;
    notifyListeners();

    final response = await _authService.registerUser(
      firstName: firstName,
      lastName: lastName,
      mobile: mobile,
      email: email,
    );

    _isLoading = false;
    notifyListeners();

    if (response["success"]) {
      return null; // Registration successful
    } else {
      _validationErrors = response["errors"]?.cast<String, String>();
      notifyListeners();
      return response["message"]; // Return error message
    }
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("user_data");

    if (userData != null) {
      _userData = jsonDecode(userData);
      if (kDebugMode) {
        print("User Data: $_userData");
      }
      notifyListeners();
    }
  }

  Future<String?> loginUserOtp({
    required String mobile,
  }) async {
    _isLoading = true;
    _validationErrors = null;
    notifyListeners();

    final response = await _authService.loginUserOtp(mobile: mobile);

    _isLoading = false;
    notifyListeners();

    if (response["success"]) {
      // Save user data locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_data", jsonEncode(response["details"]));

      _userData = response["details"];
      notifyListeners();
      return response["message"];
    } else {
      _validationErrors = response["errors"]?.cast<String, String>();
      notifyListeners();
      return response["message"];
    }
    // return null;
  }

  Future<String?> loginUser({
    required String mobile,
    required String otp,
  }) async {
    _isLoading = true;
    _validationErrors = null;
    notifyListeners();

    final response = await _authService.loginUser(mobile: mobile, otp: otp);

    _isLoading = false;
    notifyListeners();

    if (response["success"]) {
      // Save user data locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_data", jsonEncode(response["details"]));

      _userData = response["details"];
      notifyListeners();
    } else {
      _validationErrors = response["errors"]?.cast<String, String>();
      notifyListeners();
    }
    return null;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_data");
    _userData = null;
    notifyListeners();
  }

  // Future<Null> fetchCurrency() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   final result = await _authService.getCurrency();
  //   print("API Response: $result");

  //   if (result["success"]) {
  //     if (result["data"] != null && result["data"] is List) {
  //       _currencies = List<Map<String, dynamic>>.from(result["data"]);
  //       print("Currencies Loaded: $_currencies");

  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("currency_data", jsonEncode(_currencies));
  //     } else {
  //       _currencies = [];
  //     }
  //   } else {
  //     print("Error Fetching Currency: ${result["message"]}");
  //     _currencies = [];
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> loadCurrencyFromPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? storedData = prefs.getString("currency_data");

  //   if (storedData != null) {
  //     _currencies = List<Map<String, dynamic>>.from(jsonDecode(storedData));
  //     print("Loaded from SharedPreferences: $_currencies");
  //   } else {
  //     _currencies = [];
  //   }

  //   notifyListeners();
  // }

  // Future<void> fetchMainMachine() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   final result = await _authService.getMainMachine();
  //   print("API Response: $result");

  //   if (result["success"]) {
  //     if (result["data"] != null && result["data"] is List) {
  //       _machine = List<Map<String, dynamic>>.from(result["data"]);
  //       print("Main Machine Type: $_machine");

  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("main machine data", jsonEncode(_machine));
  //     } else {
  //       _machine = [];
  //     }
  //   } else {
  //     print("Error Fetching Main Machine: ${result["message"]}");
  //     _machine = [];
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }
  // Future<void> fetchMainMachine() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   final result = await _authService.getMainMachine();
  //   print("API Response: $result");

  //   if (result["success"]) {
  //     if (result["data"] != null && result["data"] is List) {
  //       // Convert to Set to remove duplicates, then back to List
  //       _machine = List<Map<String, dynamic>>.from(
  //         result["data"]
  //             .map((machine) =>
  //                 {"name": machine["name"]?.toString() ?? "Unknown"})
  //             .toSet(),
  //       );
  //       print("Main Machine Type (Unique): $_machine");

  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("main machine data", jsonEncode(_machine));
  //     } else {
  //       _machine = [];
  //     }
  //   } else {
  //     print("Error Fetching Main Machine: ${result["message"]}");
  //     _machine = [];
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> fetchMachinecat(String machineId) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final result = await _authService.machineCategories(machineId);
  //   print("API Response: $result");
  //   if (result["success"]) {
  //     if (result["data"] != null && result["data"] is List) {
  //       _machine = List<Map<String, dynamic>>.from(
  //         result["data"].map(
  //             (machine) => {"name": machine["name"]?.toString() ?? "Unknown"}),
  //       );
  //       print("Machine Categories: $_machine");
  //     } else {
  //       _machine = [];
  //     }
  //   } else {
  //     print("Error Fetching Machine Categories: ${result["message"]}");
  //     _machine = [];
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }

  // List<String> currencies = [];
  // List<String> machineTypes = [];
  // List<String> machineCategories = [];
  // List<String> machineSubCategories = [];

  // String? selectedCurrency;
  // String? selectedMachineType;
  // String? selectedMachineCategory;
  // String? selectedMachineSubCategory;

  // Future<void> fetchCurrencyData() async {
  //   try {
  //     var data = await _authService.fetchCurrencyData();
  //     currencies = data['details']
  //         .map<String>((item) => item['name'] as String)
  //         .toList();
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> fetchMachineTypes() async {
  //   try {
  //     var data = await _authService.fetchMachineTypes();
  //     machineTypes = data['details']
  //         .map<String>((item) => item['name'] as String)
  //         .toList();
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> fetchMachineCategories(String mainCatId) async {
  //   try {
  //     var data = await _authService.fetchMachineCategories(mainCatId);
  //     machineCategories = data['details']
  //         .map<String>((item) => item['name'] as String)
  //         .toList();
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> fetchMachineSubCategories(
  //     String mainCatId, String subCatId) async {
  //   try {
  //     var data =
  //         await _authService.fetchMachineSubCategories(mainCatId, subCatId);
  //     machineSubCategories = data['details']
  //         .map<String>((item) => item['name'] as String)
  //         .toList();
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // --------------------------

  List<CurrencyModel> _currencies = [];

  List<CurrencyModel> get currencies => _currencies;

  Future<void> fetchCurrencies() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse("https://mhr.sitsolutions.co.in/get_currency");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _currencies = data.map((json) => CurrencyModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load currencies");
      }
    } catch (error) {
      print("Error fetching currencies: $error");
    }

    _isLoading = false;
    notifyListeners();
  }
}
