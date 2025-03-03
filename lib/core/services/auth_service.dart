import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:machine_hour_rate/core/api/api_constants.dart';
import 'package:machine_hour_rate/models/calculationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  List<CalculationModel>? calculation;

// user new register
  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String mobile,
    String? email,
  }) async {
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

// send otp to user
  Future<Map<String, dynamic>> loginUserOtp({
    required String mobile,
  }) async {
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
        print("------------when send otp---------$responseData");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_data", jsonEncode(responseData["details"]));
        return {"success": true, "message": responseData["message"]};
      } else {
        if (kDebugMode) {
          print(
              "Error sending OTP: ${responseData["message"]}, Details: ${responseData["details"]}");
        }
        return {
          "success": false,
          "message": responseData["message"],
          "errors": responseData["details"]
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in sending OTP: $e");
      }
      return {
        "success": false,
        "message": "Something went wrong. Please try again."
      };
    }
  }

//login user with otp
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
      print("-----------Login Details-------------$responseData");
      if (responseData["status"] == "success") {
        // Save user data locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_data", jsonEncode(responseData["details"]));

        return {"success": true, "message": responseData["message"]};
      } else {
        if (kDebugMode) {
          print(
              "Login error: ${responseData["message"]}, Details: ${responseData["details"]}");
        }
        return {
          "success": false,
          "message": responseData["message"],
          "errors": responseData["details"]
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in login: $e");
      }
      return {
        "success": false,
        "message": "Something went wrong. Please try again."
      };
    }
  }

//calculation
  Future<CalculationModel?> fetchCalculationData(
      Map<String, dynamic> requestBody) async {
    final url = Uri.parse('https://mhr.sitsolutions.co.in/calculation');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (kDebugMode) {
        print("API Response Body: ${response.body}");
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success' && jsonData.containsKey("data")) {
          Map<String, dynamic> dataMap = jsonData["data"];
          CalculationModel calculationResult =
              CalculationModel.fromJson(dataMap);
          return calculationResult;
        } else {
          if (kDebugMode) {
            print("API Error Message: ${jsonData['message']}");
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print("API returned status: ${response.statusCode}");
        }
        if (kDebugMode) {
          print("Error Response: ${response.body}");
        } // More detailed error response
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while fetching calculation data: $e");
      }
      return null;
    }
  }
}
