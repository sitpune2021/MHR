import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:machine_hour_rate/core/services/auth_service.dart';
import 'package:machine_hour_rate/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  Map<String, String>? _validationErrors;

  bool get isLoading => _isLoading;
  Map<String, String>? get validationErrors => _validationErrors;

  UserModel? _userData;
  UserModel? get userData => _userData;

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
      return null;
    } else {
      _validationErrors = response["errors"]?.cast<String, String>();
      notifyListeners();
      return response["message"];
    }
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("user_data");

    if (userData != null) {
      _userData = UserModel.fromJson(json.decode(userData));
      if (kDebugMode) {
        print("User Data: $userData");
      }
      notifyListeners();
    }
  }

  Future<void> storeUserData(String mobile, String name, String email,
      String userType, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userMobile", mobile);
    await prefs.setString("userName", name);
    await prefs.setString("userEmail", email);
    await prefs.setString("userType", userType);
    await prefs.setString("userId", id);
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
      if (response.containsKey("details") && response["details"] != null) {
        _userData = UserModel.fromJson(response["details"]);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_data", jsonEncode(response["details"]));
        final userId = prefs.getString("user_data");
        if (kDebugMode) {
          print("---------------------------user ----all----- data $userId");
        }
        notifyListeners();
        return response["message"];
      } else {
        return "Send Otp.";
      }
    } else {
      _validationErrors = response["failed"]?.cast<String, String>();
      notifyListeners();
      if (response.containsKey("message")) {
        if (response["message"].toLowerCase().contains("not registered") ||
            response["message"].toLowerCase().contains("invalid")) {
          return "Number not registered, please register before you login.";
        }
      }
      return response["message"];
    }
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
      if (response["details"] != null) {
        _userData = UserModel.fromJson(response["details"]);

        if (kDebugMode) {
          print("User Data: ${_userData?.toJson()}");
        }
        print("---------------------------jhg---------$response");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_data", jsonEncode(response["details"]));
        notifyListeners();
        return response["message"];
      }
    } else {
      // _validationErrors = response["errors"]?.cast<String, String>();
      if (response.containsKey("errors") &&
          response["errors"] is Map<String, dynamic>) {
        _validationErrors = response["errors"].cast<String, String>();
      } else {
        _validationErrors = {}; // Assign an empty map if there are no errors
      }
      notifyListeners();
      if (response.containsKey("message")) {
        if (response["message"].toLowerCase().contains("invalid")) {
          return "otp is invalid, please enter valid otp.";
        }
        return response["message"];
      }
      return response["message"];
    }
    return null;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_data");
    await prefs.remove("isGuestUser");
    await prefs.getBool("guest_user");
    await prefs.clear();
    _userData = null;
    notifyListeners();
  }
}
