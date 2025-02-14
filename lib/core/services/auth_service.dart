import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String registerUrl =
      'https://mhr.sitsolutions.co.in/do_register';
  static const String loginUrl = 'https://mhr.sitsolutions.co.in/do_login';
  static const String categoriUrl = '';
  static const String subcategoriUrl = '';

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

  //  Future<List<Map<String, String>>> fetchMachineCategories() async {
  //   try {
  //     final response = await http.get(Uri.parse(categoriesUrl));

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       if (data['status'] == 'success') {
  //         List<Map<String, String>> categories = (data['details'] as List)
  //             .map((item) => {
  //                   'id': item['id'].toString(),
  //                   'name': item['name'].toString(),
  //                 })
  //             .toList();

  //         // Store in SharedPreferences
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         prefs.setString('machine_categories', jsonEncode(categories));

  //         return categories;
  //       }
  //     }
  //     return [];
  //   } catch (e) {
  //     return [];
  //   }
  // }

  // Future<List<Map<String, String>>> getStoredCategories() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? storedData = prefs.getString('machine_categories');

  //   if (storedData != null) {
  //     return List<Map<String, String>>.from(jsonDecode(storedData));
  //   }
  //   return [];
  // }
  // Future<List<Map<String, dynamic>>> fetchMachineCategories() async {
  //   try {
  //     // final response = await http.get(Uri.parse("$baseUrl/categories"));
  //     final response = await http.get(Uri.parse(categoriUrl));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       if (data['status'] == 'success') {
  //         return List<Map<String, dynamic>>.from(data['details']);
  //       }
  //     }
  //     return [];
  //   } catch (e) {
  //     print("Error fetching machine categories: $e");
  //     return [];
  //   }
  // }

//   Future<List<Map<String, String>>> fetchMachineCategories() async {
//     try {
//       final response = await http.get(Uri.parse(categoriUrl));
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['status'] == 'success') {
//           List<Map<String, String>> categories = (data['details'] as List)
//               .map((item) => {
//                     'id': item['id'].toString(),
//                     'name': item['name'].toString(),
//                   })
//               .toList();

//           // Save to SharedPreferences
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setString('machine_categories', json.encode(categories));

//           return categories;
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error fetching machine categories: $e");
//       }
//     }
//     return [];
//   }

//   Future<List<Map<String, dynamic>>> getStoredMachineCategories() async {
//   final prefs = await SharedPreferences.getInstance();
//   final String? storedCategories = prefs.getString('machineCategories');

//   if (storedCategories != null) {
//     List<dynamic> decodedData = jsonDecode(storedCategories);
//     return decodedData.cast<Map<String, dynamic>>();
//   } else {
//     return [];
//   }
// }
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response =
        await http.get(Uri.parse("https://mhr.sitsolutions.co.in/categories"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        return (data["details"] as List)
            .map((category) => {"id": category["id"], "name": category["name"]})
            .toList();
      } else {
        throw Exception("Failed to fetch categories");
      }
    } else {
      throw Exception("Failed to connect to the server");
    }
  }
}
