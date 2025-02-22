import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:machine_hour_rate/core/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
// user new register
  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String mobile,
    String? email,
  }) async {
    // Check internet connection
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return {
        "success": false,
        "message": "No internet connection. Please try again."
      };
    }

    final url = Uri.parse("${ApiConstants.baseUrl}/do_register");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "mobile": mobile,
          if (email != null && email.isNotEmpty) "email": email,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = jsonDecode(response.body);
      if (responseData["status"] == "success") {
        // Save user data locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_data", jsonEncode(responseData["details"]));

        return {"success": true, "message": responseData["message"]};
      } else {
        return {
          "success": false,
          "message": responseData["message"],
          "errors": responseData["details"]
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong. Please try again."
      };
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(userData));
    return;
  }

  Future<Map<String, dynamic>> loginUserOtp({
    required String mobile,
  }) async {
    // Check internet connection
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return {
        "success": false,
        "message": "No internet connection. Please try again."
      };
    }

    final url = Uri.parse("${ApiConstants.baseUrl}/send_otp");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "username": mobile,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = jsonDecode(response.body);
      if (responseData["status"] == "success") {
        // Save user data locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_data", jsonEncode(responseData["details"]));

        return {"success": true, "message": responseData["message"]};
      } else {
        return {
          "success": false,
          "message": responseData["message"],
          "errors": responseData["details"]
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong. Please try again."
      };
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String mobile,
    required String otp,
  }) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return {
        "success": false,
        "message": "No internet connection. Please try again."
      };
    }

    final url = Uri.parse("${ApiConstants.baseUrl}/do_login");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "username": mobile,
          "otp": otp,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = jsonDecode(response.body);
      if (responseData["status"] == "success") {
        // Save user data locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_data", jsonEncode(responseData["details"]));

        return {"success": true, "message": responseData["message"]};
      } else {
        return {
          "success": false,
          "message": responseData["message"],
          "errors": responseData["details"]
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong. Please try again."
      };
    }
  }

  // Future<void> getCurrency() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return {
  //       "success": false,
  //       "message": "No internet connection. Please try again."
  //     };
  //   }

  //   final url = Uri.parse("${ApiConstants.baseUrl}/get_currency");

  //   try {
  //     print("API Request URL: $url"); // ✅ Print full API URL
  //     final response = await http.get(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //     );

  //     print("Raw API Response: ${response.body}");

  //     final responseData = jsonDecode(response.body);

  //     if (responseData["status"] == "success" &&
  //         responseData["details"] != null) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString(
  //           "currency_data", jsonEncode(responseData["details"]));

  //   }
  // }

  // Future<Map<String, dynamic>> getMainMachine() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return {
  //       "success": false,
  //       "message": "No internet connection. Please try again."
  //     };
  //   }

  //   final url = Uri.parse("${ApiConstants.baseUrl}/maincategories");

  //   try {
  //     print("API Request URL: $url");
  //     final response = await http.get(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //     );

  //     print("Raw API Response: ${response.body}");

  //     final responseData = jsonDecode(response.body);

  //     if (responseData["status"] == "success" &&
  //         responseData["details"] != null) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString(
  //           "machine data", jsonEncode(responseData["details"]));

  //       return {"success": true, "data": responseData["details"]};
  //     } else {
  //       return {
  //         "success": false,
  //         "message": responseData["message"] ?? "No data available",
  //       };
  //     }
  //   } catch (e) {
  //     return {
  //       "success": false,
  //       "message": "Something went wrong. Please try again."
  //     };
  //   }
  // }

  // Future<Map<String, dynamic>> machineCategories(String machineId) async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return {
  //       "success": false,
  //       "message": "No internet connection. Please try again."
  //     };
  //   }

  //   final url = Uri.parse("${ApiConstants.baseUrl}/categories");
  //   print(machineId);
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: jsonEncode({
  //         {"main_cat_id": machineId}
  //       }),
  //       headers: {"Content-Type": "application/json"},
  //     );

  //     final responseData = jsonDecode(response.body);
  //     if (responseData["status"] == "success") {
  //       // Save user data locally
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("user_data", jsonEncode(responseData["details"]));

  //       return {"success": true, "message": responseData["message"]};
  //     } else {
  //       return {
  //         "success": false,
  //         "message": responseData["message"],
  //         "errors": responseData["details"]
  //       };
  //     }
  //   } catch (e) {
  //     return {
  //       "success": false,
  //       "message": "Something went wrong. Please try again."
  //     };
  //   }
  // }

  // Future<Map<String, dynamic>> machineSubcategories(String catid) async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return {
  //       "success": false,
  //       "message": "No internet connection. Please try again."
  //     };
  //   }

  //   final url = Uri.parse("${ApiConstants.baseUrl}/subcategories");
  //   if (kDebugMode) {
  //     print(catid);
  //   }
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: jsonEncode({
  //         {"cat_id": catid}
  //       }),
  //       headers: {"Content-Type": "application/json"},
  //     );

  //     final responseData = jsonDecode(response.body);
  //     if (responseData["status"] == "success") {
  //       // Save user data locally
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("user_data", jsonEncode(responseData["details"]));

  //       return {"success": true, "message": responseData["message"]};
  //     } else {
  //       return {
  //         "success": false,
  //         "message": responseData["message"],
  //         "errors": responseData["details"]
  //       };
  //     }
  //   } catch (e) {
  //     return {
  //       "success": false,
  //       "message": "Something went wrong. Please try again."
  //     };
  //   }
  // }

  // Future<Map<String, dynamic>> calculation(
  //     String catid, String subcatid) async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return {
  //       "success": false,
  //       "message": "No internet connection. Please try again."
  //     };
  //   }
  //   final url = Uri.parse("${ApiConstants.baseUrl}/calculation");
  //   if (kDebugMode) {
  //     print("Calculation API Request URL: $url");
  //   }
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: jsonEncode({
  //         "cat_id": catid,
  //         "subcat_id": subcatid,
  //       }),
  //       headers: {"Content-Type": "application/json"},
  //     );

  //     final responseData = jsonDecode(response.body);
  //     if (responseData["status"] == "success") {
  //       return {"success": true, "data": responseData["details"]};
  //     } else {
  //       return {
  //         "success": false,
  //         "message": responseData["message"],
  //         "errors": responseData["details"]
  //       };
  //     }
  //   } catch (e) {
  //     return {
  //       "success": false,
  //       "message": "Something went wrong. Please try again."
  //     };
  //   }
  // }

  // Future<Map<String, dynamic>> fetchCurrencyData() async {
  //   final response = await http
  //       .get(Uri.parse('https://mhr.sitsolutions.co.in/get_currency'));

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to load currency data');
  //   }
  // }

  // Future<Map<String, dynamic>> fetchMachineTypes() async {
  //   final response = await http
  //       .get(Uri.parse('https://mhr.sitsolutions.co.in/maincategories'));

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to load machine types');
  //   }
  // }

  // Future<Map<String, dynamic>> fetchMachineCategories(String mainCatId) async {
  //   final response = await http.post(
  //     Uri.parse('https://mhr.sitsolutions.co.in/categories'),
  //     body: json.encode({"main_cat_id": 1}),
  //   );

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to load machine categories');
  //   }
  // }

  // Future<Map<String, dynamic>> fetchMachineSubCategories(
  //     String mainCatId, String subCatId) async {
  //   final response = await http.post(
  //       Uri.parse('https://mhr.sitsolutions.co.in/subcategories'),
  //       body: json.encode({"main_cat_id": 1, "sub_cat_id": 1}));
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to load machine sub categories');
  //   }
  // }
}
