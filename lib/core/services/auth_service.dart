import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
//   static const String baseUrl = 'https://mhr.sitsolutions.co.in';

//   Future<Map<String, dynamic>> registerUser({
//     required String firstName,
//     required String lastName,
//     required String mobile,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('$baseUrl/do_register'),
//       );

//       request.fields['first_name'] = firstName;
//       request.fields['last_name'] = lastName;
//       request.fields['mobile'] = mobile;
//       request.fields['email'] = email;
//       request.fields['password'] = password;

//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();
//       var jsonResponse = jsonDecode(responseData);

//       if (response.statusCode == 200) {
//         if (jsonResponse['status'] == 'success') {
//           return {'success': true, 'message': jsonResponse['message']};
//         } else {
//           // Collect validation error messages
//           Map<String, dynamic> errorDetails = jsonResponse['details'] ?? {};
//           return {
//             'success': false,
//             'message': jsonResponse['message'] ??
//                 'Validation failed ! Please check the errors',
//             'errors': errorDetails,
//           };
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'Registration failed due to server error'
//         };
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error: $e');
//       }
//       return {
//         'success': false,
//         'message': 'Something went wrong while registering! Please try again.'
//       };
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
  static const String registerUrl =
      'https://mhr.sitsolutions.co.in/do_register';
  static const String loginUrl = 'https://mhr.sitsolutions.co.in/do_login';

  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "mobile": mobile,
          "email": email,
          "password": password,
        }),
      );
      final responseData = jsonDecode(response.body);
      print("API Response: $responseData");
      return responseData;
      // print("$response");
    } catch (e) {
      return {'status': 'error', 'message': 'Something went wrong. Try again.'};
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(userData));
    print("$registerUrl");
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      final responseData = jsonDecode(response.body);
      print("API Response: $responseData");

      if (responseData["status"] == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userData", jsonEncode(responseData["details"]));
        return responseData;
      } else {
        return responseData;
      }
    } catch (e) {
      print("Login Error: $e");
      return {"status": "failed", "message": "Something went wrong!"};
    }
  }
}
