// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesHelper {
//   static Future<void> setSelectedCurrency(String currency) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('selectedCurrency', currency);
//   }

//   static Future<void> setSelectedMachineType(String type) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('selectedMachineType', type);
//   }

//   static Future<void> setSelectedMachineCategory(String category) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('selectedMachineCategory', category);
//   }

//   static Future<void> setSeletedMachineSubCategory(String subcategory) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('selectedMachineSubCategory', subcategory);
//   }

//   static Future<String?> getSelectedCurrency() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('selectedCurrency');
//   }

//   static Future<String?> getSelectedMachineType() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('selectedMachineType');
//   }

//   static Future<String?> getSelectedMachineCategory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('selectedMachineCategory');
//   }

//   static Future<String?> getSeletedMachineSubCategory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('selectedMachineSubCategory');
//   }
// }
