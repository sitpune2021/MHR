import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  Map<String, String>? _validationErrors;

  bool get isLoading => _isLoading;
  Map<String, String>? get validationErrors => _validationErrors;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

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

  List<Map<String, dynamic>> _categories = [];

  List<Map<String, dynamic>> get categories => _categories;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final service = AuthService();
      _categories = await service.fetchCategories();

      // Store in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("categories", _categories.toString());
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
