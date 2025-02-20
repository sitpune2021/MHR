import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:machine_hour_rate/core/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String categoriUrl = '';
  static const String subcategoriUrl = '';

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
    // Check internet connection
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

  Future<Map<String, dynamic>> getCurrency() async {
    // Check internet connection
    var connectivityResult = await Connectivity().checkConnectivity();
  }
}
