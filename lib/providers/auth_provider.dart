// import 'package:flutter/material.dart';
// import 'package:machine_hour_rate/core/services/auth_service.dart';

// class AuthProvider with ChangeNotifier {
//   final AuthService _authService = AuthService();
//   bool _isLoading = false;
//   Map<String, String> _validationErrors = {};

//   bool get isLoading => _isLoading;
//   Map<String, String> get validationErrors => _validationErrors;

//   Future<String?> registerUser({
//     required String firstName,
//     required String lastName,
//     required String mobile,
//     required String email,
//     required String password,
//   }) async {
//     _isLoading = true;
//     _validationErrors.clear();
//     notifyListeners();

//     final response = await _authService.registerUser(
//       firstName: firstName,
//       lastName: lastName,
//       mobile: mobile,
//       email: email,
//       password: password,
//     );

//     _isLoading = false;
//     notifyListeners();

//     if (response['success']) {
//       return null; // Registration successful
//     } else {
//       // Store validation errors
//       if (response.containsKey('errors')) {
//         _validationErrors = Map<String, String>.from(response['errors']);
//       }
//       notifyListeners();
//       return response[" invalid"]; // Return error message
//     }
//   }
// }

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
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _validationErrors = null;
    notifyListeners();

    final response = await _authService.registerUser(
      firstName: firstName,
      lastName: lastName,
      mobile: mobile,
      email: email,
      password: password,
    );

    _isLoading = false;

    if (response['status'] == 'success') {
      await _authService.saveUserData({
        "first_name": firstName,
        "last_name": lastName,
        "mobile": mobile,
        "email": email,
      });
      notifyListeners();
      return null;
    } else if (response['status'] == 'error') {
      if (response['details'] != null) {
        _validationErrors = Map<String, String>.from(response['details']);
      }
      notifyListeners();
      return response['message'];
    }
    return 'Something went wrong. Try again.';
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userData');
  }

  Future<String> loginUser(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await AuthService().login(username, password);
    _isLoading = false;
    notifyListeners();

    if (response["status"] == "success") {
      _userData = response["details"];
      return "success";
    } else {
      return response["message"];
    }
  }
}
