// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/models/calculationlistModel.dart';
import 'package:machine_hour_rate/providers/auth_provider.dart';
import 'package:machine_hour_rate/views/calculation/mhr_view_calculation.dart';
import 'package:machine_hour_rate/views/calculation/updated_calculation.dart';
import 'package:machine_hour_rate/views/home/guest_home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGuestUser = false;
  String userName = " ";
  List<CalculationListModel> calculations = [];
  // List<CalculationListModel> calList = [];
  bool isLoading = true;
  Timer? _timer;
  bool showAll = false;
  final int shimmerDuration = 60;

  @override
  void initState() {
    super.initState();
    _loadUserStatus();
    fetchCalculations();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        fetchCalculations();
      } else {
        timer.cancel();
      }
    });
  }

  // void onUserLogin(String userId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // Save user ID and status
  //   await prefs.setString("userId", userId);
  //   await prefs.setBool("isGuestUser", false);

  //   // Fetch calculations for the logged-in user
  //   fetchCalculations(userId: userId);
  // }

  Future<void> _loadUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isGuestUser = prefs.getBool("isGuestUser") ?? false;
      userName = isGuestUser
          ? "Guest User"
          : (prefs.getString("userName") ?? "Guest User");
      // });
      if (!isGuestUser) {
        String? userId = prefs.getString("userId");
        fetchCalculations(userId: userId);
      } else {
        fetchCalculations();
      }
    });
  }

// calculation list
  Future<void> fetchCalculations({String? userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("http://mhr.sitsolutions.co.in/calculation_list");
    var userid = prefs.getString("user_id");
    print("--------------log--------------$userid");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userid}),
      );
      print("---------------------------list -----------${response.body}");
      if (kDebugMode) {
        print("Fetch Response Status Code: ${response.statusCode}");
      }
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData["status"] == "success") {
          List<dynamic> details = jsonData["details"];
          List<CalculationListModel> fetchedCalculations = details
              .map((item) => CalculationListModel.fromJson(item))
              .toList();

          if (mounted) {
            setState(() {
              calculations = fetchedCalculations;
              isLoading = false;
            });

            if (kDebugMode) {
              print("Updated calculations count: ${calculations.length}");
            }
          }
        } else {
          if (kDebugMode) {
            print("Failed to load calculations: ${jsonData['message']}");
          }
        }
      } else {
        if (kDebugMode) {
          print("Failed to load data, status code: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      if (kDebugMode) {
        print("Error fetching calculations: $e");
      }
    }
  }

// calculation delete
  Future<void> deleteCalculation(String id) async {
    final url = Uri.parse("http://mhr.sitsolutions.co.in/delete_calculation");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData["status"] == "success") {
          setState(() {
            calculations.removeWhere((item) => item.id == id);
          });
        }
      } else {
        throw Exception("Failed to delete calculation");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting calculation: $e");
      }
    }
  }

  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Delete Calculation",
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          "Are you sure you want to delete this calculation?",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.blue, fontSize: 18)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteCalculation(id);
            },
            child: const Text("Delete",
                style: TextStyle(color: Colors.red, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateCalculation(
      String id,
      String mainCatId,
      String currencyId,
      String subcatId,
      Map<String, dynamic> updatedData) async {
    Map<String, dynamic> jsonBody = {
      "id": id,
      "currency_id": currencyId,
      "subcat_id": subcatId,
    };
    if (mainCatId == "1") {
      if (kDebugMode) {
        print("Updated Data: $updatedData");
      }
      jsonBody["main_cat_id"] = 1;
      jsonBody["power_consumption"] = updatedData["power_consumption"];
      jsonBody["maintanance_cost"] = updatedData["maintanance_cost"];
      jsonBody["machine_purchase_price"] =
          updatedData["machine_purchase_price"];
      jsonBody["machine_life"] = updatedData["machine_life"];
      jsonBody["salvage_value"] = updatedData["salvage_value"];
      jsonBody["power_cost_per_unit"] = updatedData["power_cost"];
      if (kDebugMode) {
        print("-----------POWER COST-----------${updatedData["power_cost"]}");
      }
      jsonBody["operator_wage"] = updatedData["operator_wage"];
      jsonBody["consumable_cost"] = updatedData["consumable_cost"];
      jsonBody["factory_rent"] = updatedData["factory_rent"];
      jsonBody["operating_hours"] = updatedData["operating_hours"];
      jsonBody["working_days"] = updatedData["working_days"];

      if (kDebugMode) {
        print("Debugging Parameters:");
        print("main_cat_id: ${jsonBody['main_cat_id']}");
        print("power_consumption: ${jsonBody['power_consumption']}");
        print("maintanance_cost: ${jsonBody['maintanance_cost']}");
        print("machine_purchase_price: ${jsonBody['machine_purchase_price']}");
        print("machine_life: ${jsonBody['machine_life']}");
        print("salvage_value: ${jsonBody['salvage_value']}");
        print("power_cost_per_unit: ${jsonBody['power_cost_per_unit']}");
        print("operator_wage: ${jsonBody['operator_wage']}");
        print("consumable_cost: ${jsonBody['consumable_cost']}");
        print("factory_rent: ${jsonBody['factory_rent']}");
        print("operating_hours: ${jsonBody['operating_hours']}");
        print("working_days: ${jsonBody['working_days']}");
      }
    } else if (mainCatId == "2") {
      jsonBody["main_cat_id"] = 2;
      jsonBody["maintanance_cost"] = updatedData["maintanance_cost"];
      jsonBody["machine_purchase_price"] =
          updatedData["machine_purchase_price"];
      jsonBody["machine_life"] = updatedData["machine_life"];
      jsonBody["salvage_value"] = updatedData["salvage_value"];
      jsonBody["fuel_cost_per_hour"] = updatedData["fuel_cost_per_hour"];
      jsonBody["operator_wage"] = updatedData["operator_wage"];
      jsonBody["consumable_cost"] = updatedData["consumable_cost"];
      jsonBody["factory_rent"] = updatedData["factory_rent"];
      jsonBody["operating_hours"] = updatedData["operating_hours"];
      jsonBody["working_days"] = updatedData["working_days"];
      if (kDebugMode) {
        print("Debugging Parameters After Assignment:");
        print("main_cat_id: ${jsonBody['main_cat_id']}");
        print("maintanance_cost: ${jsonBody['maintanance_cost']}");
        print("machine_purchase_price: ${jsonBody['machine_purchase_price']}");
        print("machine_life: ${jsonBody['machine_life']}");
        print("salvage_value: ${jsonBody['salvage_value']}");
        print("fuel_cost_per_hour: ${jsonBody['fuel_cost_per_hour']}");
        print("operator_wage: ${jsonBody['operator_wage']}");
        print("consumable_cost: ${jsonBody['consumable_cost']}");
        print("factory_rent: ${jsonBody['factory_rent']}");
        print("operating_hours: ${jsonBody['operating_hours']}");
        print("working_days: ${jsonBody['working_days']}");
      }
    } else {
      if (kDebugMode) {
        print("Invalid main_cat_id: $mainCatId");
      }
      return;
    }
    final url = Uri.parse("http://mhr.sitsolutions.co.in/update_calculation");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(jsonBody),
      );
      if (kDebugMode) {
        print("Response Status Code: ${response.statusCode}");
        print("Response Headers: ${response.headers}");
        print("Response Body: ${response.body}");
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("------------------update response-----------------$response");
        }
        Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData["status"] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Calculation Updated Successfully.")));
          await fetchCalculations();
          if (kDebugMode) {
            print("Calculations refreshed, new count: ${calculations.length}");
          }
          if (kDebugMode) {
            print(
                "-------------------update respnse pparemeter------$jsonData");
          }
        } else {
          if (kDebugMode) {
            print("Update failed: ${jsonData['message']}");
          }
        }
      } else {
        // Log server error
        if (kDebugMode) {
          print("Server error: ${response.statusCode}");
        }
      }
    } catch (e) {
      // Handle any exceptions thrown during the request
      if (kDebugMode) {
        print("Error updating calculation: $e");
      }
    }
  }

  // ...
  void _showEditDialog(CalculationListModel calculation) {
    TextEditingController fuelCostController =
        TextEditingController(text: calculation.fuelCostPerHour?.toString());
    TextEditingController powerConsumptionController =
        TextEditingController(text: calculation.powerConsumption?.toString());
    TextEditingController maintenanceCostController =
        TextEditingController(text: calculation.maintananceCost?.toString());
    TextEditingController machinePurchasePriceController =
        TextEditingController(
            text: calculation.machinePurchasePrice?.toString());
    TextEditingController machineLifeController =
        TextEditingController(text: calculation.machineLife?.toString());
    TextEditingController salvageValueController =
        TextEditingController(text: calculation.salvageValue?.toString());
    TextEditingController powerCostController =
        TextEditingController(text: calculation.powerCostPerUnit?.toString());
    TextEditingController operatorWageController =
        TextEditingController(text: calculation.operatorWage?.toString());
    TextEditingController consumableCostController =
        TextEditingController(text: calculation.consumableCost?.toString());
    TextEditingController factoryRentController =
        TextEditingController(text: calculation.factoryRent?.toString());
    TextEditingController operatingHoursController =
        TextEditingController(text: calculation.operatingHours?.toString());
    TextEditingController workingDaysController =
        TextEditingController(text: calculation.workingDays?.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Edit Calculation"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (calculation.powerConsumption != null)
                  TextField(
                    controller: powerConsumptionController,
                    decoration:
                        const InputDecoration(labelText: "Power Consumption"),
                    keyboardType: TextInputType.number,
                  ),
                if (calculation.powerCostPerUnit != null)
                  TextField(
                    controller: powerCostController,
                    decoration: const InputDecoration(labelText: "Power Cost"),
                    keyboardType: TextInputType.number,
                  ),
                if (calculation.fuelCostPerHour != null)
                  TextField(
                    controller: fuelCostController,
                    decoration: const InputDecoration(labelText: "Fuel Cost"),
                    keyboardType: TextInputType.number,
                  ),
                TextField(
                  controller: maintenanceCostController,
                  decoration:
                      const InputDecoration(labelText: "Maintenance Cost"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: machinePurchasePriceController,
                  decoration: const InputDecoration(
                      labelText: "Machine Purchase Price"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: machineLifeController,
                  decoration: const InputDecoration(labelText: "Machine Life"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: salvageValueController,
                  decoration: const InputDecoration(labelText: "Salvage Value"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: operatorWageController,
                  decoration: const InputDecoration(labelText: "Operator Wage"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: consumableCostController,
                  decoration:
                      const InputDecoration(labelText: "Consumable Cost"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: factoryRentController,
                  decoration: const InputDecoration(labelText: "Factory Rent"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: operatingHoursController,
                  decoration:
                      const InputDecoration(labelText: "Operating Hours"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: workingDaysController,
                  decoration: const InputDecoration(labelText: "Working Days"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () async {
                Map<String, dynamic> updatedData = {
                  "power_consumption":
                      powerConsumptionController.text.isNotEmpty
                          ? double.tryParse(powerConsumptionController.text)
                          : null,
                  "power_cost": powerCostController.text.isNotEmpty
                      ? double.tryParse(powerCostController.text)
                      : null,
                  "fuel_cost": fuelCostController.text.isNotEmpty
                      ? double.tryParse(fuelCostController.text)
                      : null,
                  "maintanance_cost":
                      double.tryParse(maintenanceCostController.text),
                  "machine_purchase_price":
                      double.tryParse(machinePurchasePriceController.text),
                  "machine_life": double.tryParse(machineLifeController.text),
                  "salvage_value": double.tryParse(salvageValueController.text),
                  "operator_wage": double.tryParse(operatorWageController.text),
                  "consumable_cost":
                      double.tryParse(consumableCostController.text),
                  "factory_rent": double.tryParse(factoryRentController.text),
                  "operating_hours":
                      double.tryParse(operatingHoursController.text),
                  "working_days": double.tryParse(workingDaysController.text),
                };

                // Call to update calculation
                await _updateCalculation(
                  calculation.id ?? '',
                  calculation.mainCatId ?? '',
                  calculation.currencyId ?? '',
                  calculation.subcatId ?? '',
                  updatedData,
                );
                if (mounted) {
                  await fetchCalculations();
                }
                Navigator.pop(context);
                var cal_id = calculation.id ?? '';
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MHRCalScreen(viewid: cal_id),
                  ),
                );
              },
              child: const Text(
                "Update",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        SharedPreferences prefs = snapshot.data!;
        String? userId = prefs.getString('user_id');
        bool? guestUser = prefs.getBool("guest_user");

        if (guestUser == true) {
          return const GuestHome();
        } else {
          final authProvider = Provider.of<AuthProvider>(context);
          final user = authProvider.userData;
          List<CalculationListModel> displayedCalculations =
              showAll ? calculations : calculations.take(10).toList();
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All Calculations (${calculations.length})",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showAll = !showAll;
                          });
                        },
                        child: Text(
                          showAll ? "Collapse" : "View All",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: showAll ? Colors.red : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: isLoading
                        ? Center(child: _buildShimmerLoader())
                        : calculations.isEmpty
                            ? const Center(child: Text("No data available"))
                            : ListView.builder(
                                padding: const EdgeInsets.all(5),
                                itemCount: calculations.length,
                                itemBuilder: (context, index) {
                                  final calculation = calculations[index];
                                  final cal_id = calculations[index].id;

                                  return InkWell(
                                    onTap: () {
                                      print(
                                          "-------------------calcution id-----------${cal_id}");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MHRCalculatorsScreen(
                                                  viewid:
                                                      cal_id ?? "", //----------
                                                )),
                                      );
                                    },
                                    child: Card(
                                      color: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 4,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                _showEditDialog(calculation);
                                              },
                                            ),
                                            Text(
                                              "Calculation ${calculation.id}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${calculation.currencyId == 2 ? "*" : calculation.currencyId == 1 ? '\$' : ''} ${calculation.machineHourRate}",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close,
                                                  color: Colors.red),
                                              onPressed: () {
                                                if (calculation.id != null) {
                                                  confirmDelete(
                                                      calculation.id!);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      itemCount: 10, // Simulating 10 shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          period: Duration(seconds: shimmerDuration),
          child: Card(
            color: Colors.grey[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 100, height: 20, color: Colors.white),
                  Container(width: 80, height: 20, color: Colors.white),
                  Container(width: 40, height: 20, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
