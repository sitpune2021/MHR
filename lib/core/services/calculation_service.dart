import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:machine_hour_rate/models/calculationlistModel.dart';

// class ApiService {
//   // List<CalculationListModel>? calculation;

//   Future<Object?> fetchCalculationList(Map<String, dynamic> requestBody) async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       return {
//         "success": false,
//         "message": "No internet connection. Please try again."
//       };
//     }
//     final url = Uri.parse("${ApiConstants.baseUrl}/calculation_list");
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'success') {
//           return CalculationListModel.fromJson(data['details'][0]);
//         } else {
//           throw Exception('Failed to load calculation list');
//         }
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       return null;
//     }
//   }
// }

class CalculationService {
  final String baseUrl = "https://mhr.sitsolutions.co.in/calculation_list";

  Future<CalculationListModel?> fetchCalculationList(
      // {
      // required String id,
      // required String userId,
      // required String mainCatId,
      // required String subcatId,
      // }
      ) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == "success" &&
            jsonResponse['details'] != null &&
            jsonResponse['details'].isNotEmpty) {
          return CalculationListModel.fromJson(jsonResponse['details'][0]);
        } else {
          print("Failed to fetch calculation data");
          return null;
        }
      } else {
        print("Failed to fetch data: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error fetching calculation data: $error");
      return null;
    }
  }
}
