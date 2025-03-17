// ignore_for_file: library_prefixes, deprecated_member_use, use_build_context_synchronously, unrelated_type_equality_checks, unused_element

import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/db/database_helper.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
import 'package:machine_hour_rate/models/calculationModel.dart';
import 'package:machine_hour_rate/models/mainmachineModel.dart';
import 'package:machine_hour_rate/providers/calculationprovider.dart';
import 'package:machine_hour_rate/views/home/home_page_view.dart';
import 'package:machine_hour_rate/views/home/home_screen.dart';
import 'package:machine_hour_rate/views/login/login_screen.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MHRCalculatorScreen extends StatefulWidget {
  MHRCalculatorScreen({super.key});

  final Map<String, double> dataMap = {
    "Flutter": 40,
    "React Native": 30,
    "Xamarin": 15,
    "Ionic": 15,
  };

  final List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  @override
  State<MHRCalculatorScreen> createState() => _MHRCalculatorScreenState();
}

class _MHRCalculatorScreenState extends State<MHRCalculatorScreen> {
  String? machineHourRate;
  get dataMap => null;
  MainMachineModel? selectedMachineId;
  get colorList => null;
  Map<String, dynamic> storedValues = {};
  Map<String, dynamic> resultValue = {};

  @override
  void initState() {
    super.initState();
    _loadStoredValues();
    _loadCalculationResult();
  }

  Future<void> _loadCalculationResult() async {
    CalculationModel? loadedCalculation =
        await SharedPrefsHelper.getCalculationResult();
    if (loadedCalculation != null) {
      final provider = Provider.of<CalculationProvider>(context, listen: false);
      provider.calculation = loadedCalculation;
      provider.notifyListeners(); // Notify listeners to rebuild
    }
  }

  Future<void> _saveInputValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("power_consumption", "");
    await prefs.setString("maintanance_cost", "");
    await prefs.setString("machine_purchase_price", "");
    await prefs.setString("machine_life", "");
    await prefs.setString("salvage_value", "");
    await prefs.setString("power_cost", "");
    await prefs.setString("fuel_cost_per_hour", "");
    await prefs.setString("operator_wage", "");
    await prefs.setString("consumable_cost", "");
    await prefs.setString("factory_rent", "");
    await prefs.setString("operating_hours", "");
    await prefs.setString("working_days", "");
    await prefs.setString("machine_hour_rate", "");
  }

  Future<void> _loadStoredValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storedValues = {
        "main_cat_id": prefs.getString("main_cat_id"),
        "currency_id": prefs.getString("currency_id"),
        "power_consumption": prefs.getString("power_consumption"),
        "maintanance_cost": prefs.getString("maintanance_cost"),
        "machine_purchase_price": prefs.getString("machine_purchase_price"),
        "machine_life": prefs.getString("machine_life"),
        "salvage_value": prefs.getString("salvage_value"),
        "power_cost": prefs.getString("power_cost"),
        "fuel_cost_per_hour": prefs.getString("fuel_cost_per_hour"),
        "operator_wage": prefs.getString("operator_wage"),
        "consumable_cost": prefs.getString("consumable_cost"),
        "factory_rent": prefs.getString("factory_rent"),
        "operating_hours": prefs.getString("operating_hours"),
        "working_days": prefs.getString("working_days"),
        "machine_hour_rate": prefs.getString("mhr"),
      };
    });
    if (kDebugMode) {
      print(
          "--------------------------MHRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR------------------${prefs.getString("mhr")}");
    }
    if (kDebugMode) {
      print("------------------SAVE----ALL------DATA---------$storedValues");
    }
  }

//down load
  Future<void> _downloadPDF(BuildContext context, dynamic result) async {
    if (result.mhr == null || result.mhr!.isEmpty) {
      _showMessage(context, "Machine Hour Rate is empty!");
      return;
    }

    if (!await _requestStoragePermission()) {
      return; // Permission denied
    }

    // Get external storage directory (Scoped Storage)
    Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      _showMessage(context, "Unable to find storage directory!");
      return;
    }

    // Use Downloads directory instead
    String documentsPath =
        "/storage/emulated/0/Download"; // Standard Downloads folder
    String filePath = "$documentsPath/machine_hour_rate.pdf";

    final pdf = pdfLib.Document();
    pdf.addPage(
      pdfLib.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pdfLib.Context context) => pdfLib.Center(
          child: pdfLib.Column(
            mainAxisAlignment: pdfLib.MainAxisAlignment.start,
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: [
              pdfLib.Text("Machine Hour Rate Overview",
                  style: const pdfLib.TextStyle(fontSize: 24)),
              pdfLib.SizedBox(height: 20),
              pdfLib.Text("Calcultaion Result",
                  style: const pdfLib.TextStyle(fontSize: 24)),
              pdfLib.SizedBox(height: 20),
              //calculation
              pdfLib.Text("Machine Hour Rate: ${result.mhr}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Depreciation: ${result.depreciation}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Power Cost: ${result.powerCost}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Operator Wages: ${result.operatorWages}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Total Cost Per Year: ${result.totalCostPerYear}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Total Working Hours: ${result.totalWorkingHours}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Input Values",
                  style: const pdfLib.TextStyle(fontSize: 24)),
              pdfLib.SizedBox(height: 20),
              // inpute
              pdfLib.Text(
                  "Maintenance Cost: ${storedValues['maintanance_cost']}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text(
                  "Machine Purchase Price: ${storedValues['machine_purchase_price']}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Machine Life: ${storedValues['machine_life']}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Salvage Value: ${storedValues['salvage_value']}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              // condtion
              if (storedValues['main_cat_id'] == '1') ...[
                pdfLib.Text(
                    "Power Consumption: ${storedValues['power_consumption'] ?? '0'}",
                    style: const pdfLib.TextStyle(fontSize: 20)),
                // condtion
                pdfLib.Text("Power Cost: ${storedValues['power_cost'] ?? '0'}",
                    style: const pdfLib.TextStyle(fontSize: 20)),
              ],
              // condition
              if (storedValues['main_cat_id'] == '2') ...[
                pdfLib.Text(
                    "Fuel Cost: ${storedValues['fuel_cost_per_hour'] ?? '0'}",
                    style: const pdfLib.TextStyle(fontSize: 20)),
              ],
              pdfLib.Text("Operator Wage: ${storedValues['operator_wage']}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Consumable Cost: ${storedValues['consumable_cost']}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Factory Rent: ${storedValues['factory_rent']}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Operating Hours: ${storedValues['operating_hours']}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Working Days: ${storedValues['working_days']}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.SizedBox(height: 10),
              pdfLib.Text("Generated on: ${DateTime.now()}"),
            ],
          ),
        ),
      ),
    );

    await _savePDF(
      context,
      pdf,
    );
  }

  Future<void> _savePDF(BuildContext context, pdfLib.Document pdf) async {
    try {
      if (!await _requestStoragePermission()) {
        _showMessage(context, "Storage permission denied!");
        return;
      }

      // Define the path to the public Downloads folder
      String downloadsPath =
          "/storage/emulated/0/Download"; // Public Downloads folder
      Directory downloadsDir = Directory(downloadsPath);

      // Create the Downloads directory if it doesn't exist
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      // Define the file path
      String filePath = "${downloadsDir.path}/machine_hour_rate.pdf";
      final file = File(filePath);

      // Save the PDF
      await file.writeAsBytes(await pdf.save());

      // Show a success message
      _showMessage(context, "PDF saved at $filePath");
      if (kDebugMode) {
        print("PDF saved at $filePath");
      }

      // Open the file after saving
      OpenFilex.open(filePath);
    } catch (e) {
      _showMessage(context, "Failed to save PDF: $e");
      if (kDebugMode) {
        print("Download failed: $e");
      }
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Check the Android version to handle permissions accordingly
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final androidVersion = androidInfo.version.sdkInt;

      if (androidVersion < 30) {
        // Android 10 and below
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            return false; // If permission is denied, return false
          }
        }
        return true; // Permission granted
      } else {
        // Android 11 and above
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            return false; // If permission is denied, return false
          }
        }
        return true; // Permission granted
      }
    }

    return true; // Non-Android platforms don't need this
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculationProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          return false;
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: FutureBuilder(
              future: _loadCalculationResult(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.values) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final result = provider.calculationResult;
                  return SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("RESULT VIEW",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 200,
                            width: 280,
                            child: PieChart(
                              dataMap: widget.dataMap,
                              animationDuration:
                                  const Duration(milliseconds: 800),
                              chartType: ChartType.ring,
                              colorList: widget.colorList,
                              legendOptions:
                                  const LegendOptions(showLegends: true),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${result!.mhr?.toString()}",
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                const Center(
                                  child: Text(
                                    "Machine Hour Rate",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Depreciation",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      ": ${result.depreciation?.toString()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Power Cost",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      ": ${result.powerCost?.toString()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Operator Wages",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      ": ${result.operatorWages?.toString()}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total Cost Per Year",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      ": ${result.totalCostPerYear?.toString()}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total Working Hours",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      ": ${result.totalWorkingHours?.toString()}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Your Input ",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 60, right: 60, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Maintenance Cost",
                                        style: TextStyle(fontSize: 16)),
                                    Text(
                                        ": ${storedValues['maintanance_cost']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Machine Purchase Price",
                                        style: TextStyle(fontSize: 16)),
                                    Text(
                                        ": ${storedValues['machine_purchase_price']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Machine Life",
                                        style: TextStyle(fontSize: 16)),
                                    Text(": ${storedValues['machine_life']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Salvage Value",
                                        style: TextStyle(fontSize: 16)),
                                    Text(": ${storedValues['salvage_value']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                if (storedValues['main_cat_id'] == '1') ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Power Consumption",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        ": ${storedValues['power_consumption']}",
                                        style: const TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Power Cost",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        ": ${storedValues['power_cost']}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                                if (storedValues['main_cat_id'] == '2') ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Fuel Cost",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        ": ${storedValues['fuel_cost_per_hour']}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Operator Wage",
                                        style: TextStyle(fontSize: 16)),
                                    Text(": ${storedValues['operator_wage']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Consumable Cost",
                                        style: TextStyle(fontSize: 16)),
                                    Text(": ${storedValues['consumable_cost']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Factory Rent",
                                        style: TextStyle(fontSize: 16)),
                                    Text(": ${storedValues['factory_rent']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Operating Hours",
                                        style: TextStyle(fontSize: 16)),
                                    Text(": ${storedValues['operating_hours']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Working Days",
                                        style: TextStyle(fontSize: 16)),
                                    Text(": ${storedValues['working_days']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Save Calculation
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kButtonColor,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          String? userId =
                                              prefs.getString('user_id');

                                          bool? guestUser =
                                              prefs.getBool("guest_user");

                                          if (userId == null &&
                                              guestUser == true) {
                                            int currentCount =
                                                await DatabaseHelper()
                                                    .countGuestCalculations();
                                            if (currentCount >= 10) {
                                              _showLimitExceededDialog(context);
                                            } else {
                                              _showGuestDialog(context);
                                            }
                                          } else {
                                            await SaveCalculation(() {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const HomeScreen()));
                                            }).saveData(context);
                                          }
                                        },
                                        icon: const Icon(Icons.save),
                                        label: const Text("Save"),
                                      ),
                                      //pdf download
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kButtonColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        onPressed: () =>
                                            _downloadPDF(context, result),
                                        icon: const Icon(Icons.download),
                                        label: const Text("Download"),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              })),
    );
  }

  Widget buildAlignedRow({required String label, required dynamic value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        const Expanded(
          child: Text(
            ":",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: Text(
            value.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Future<void> saveDataForGuest(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentCount = await DatabaseHelper().countGuestCalculations();

    if (currentCount >= 10) {
      _showLimitExceededDialog(context);
      return;
    }

    String? mainCatId = prefs.getString('main_cat_id');

    String? currencyId = prefs.getString('currency_id');
    String? currencyAmount = prefs.getString('selectedCurrencyName');
    String? subcatId = prefs.getString('selectedMachinesubcatId');

    // Numeric values
    String? maintenanceCost = prefs.getString("maintanance_cost");
    String? machinePurchasePrice = prefs.getString('machine_purchase_price');
    String? machineLife = prefs.getString('machine_life');
    String? salvageValue = prefs.getString('salvage_value');
    String? operatorWage = prefs.getString('operator_wage');
    String? consumableCost = prefs.getString('consumable_cost');
    String? factoryRent = prefs.getString('factory_rent');
    String? operatingHours = prefs.getString('operating_hours');
    String? workingDays = prefs.getString("working_days");
    String? depreciation = prefs.getString('depreciation');
    String? powerCosts = prefs.getString('power_costs');
    String? operatorWages = prefs.getString('operator_wages');
    String? totalCostPerYear = prefs.getString('total_cost_per_year');
    String? totalWorkingHours = prefs.getString('total_working_hours');
    String? machineHourRate = prefs.getString('mhr');

    String? powerConsumption = prefs.getString("power_consumption");
    String? powerCost = prefs.getString("power_cost");
    String? fuelCost = prefs.getString("fuel_cost_per_hour");
    Map<String, dynamic> requestBody = {
      "main_cat_id": mainCatId,
      "currency_id": currencyId,
      "currency_amount": currencyAmount,
      "subcat_id": subcatId,
      "maintanance_cost": maintenanceCost,
      "machine_purchase_price": machinePurchasePrice,
      "machine_life": machineLife,
      "salvage_value": salvageValue,
      "operator_wage": operatorWage,
      "consumable_cost": consumableCost,
      "factory_rent": factoryRent,
      "operating_hours": operatingHours,
      "working_days": workingDays,
      "depreciation": depreciation,
      "power_cost": powerCosts,
      "operator_wages": operatorWages,
      "total_cost_per_year": totalCostPerYear,
      "total_working_hours": totalWorkingHours,
      "machine_hour_rate": machineHourRate,
    };
    if (mainCatId == '1') {
      requestBody["power_consumption"] = powerConsumption;
      requestBody["power_cost_per_unit"] = powerCost;
    } else if (mainCatId == '2') {
      requestBody["fuel_cost_per_hour"] = fuelCost;
    }
    int result = await DatabaseHelper().insertCalculation(requestBody);

    if (result == 1) {
      if (kDebugMode) {
        print("-----------------------------------------data inserted");
      }
    } else {
      if (kDebugMode) {
        print("-----------------------------------------data failed");
      }
    }
  }

  void _showLimitExceededDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Limit Exceeded"),
          content: const Text(
              "You can only save up to 10 calculations as a guest user."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showGuestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Guest User"),
          content: const Text(
              "You are currently a guest user. Would you like to continue as a guest or log in/register?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Continue as Guest"),
              onPressed: () async {
                Navigator.of(context).pop();
                await saveDataForGuest(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            TextButton(
              child: const Text("Log In / Register"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
            ),
          ],
        );
      },
    );
  }
}

class SaveCalculation {
  final Function onSuccessCallback;

  SaveCalculation(this.onSuccessCallback);

  Future<void> saveData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? mainCatId = prefs.getString('main_cat_id');
    String? userId = prefs.getString('user_id');
    if (kDebugMode) {
      print("-----------------USER-----LOGIN-------ID---------------$userId");
    }
    String? currencyId = prefs.getString('currency_id');
    String? currencyAmount = prefs.getString('selectedCurrencyName');
    String? subcatId = prefs.getString('selectedMachinesubcatId');

    // Numeric values
    String? maintenanceCost = prefs.getString("maintanance_cost");
    String? machinePurchasePrice = prefs.getString('machine_purchase_price');
    String? machineLife = prefs.getString('machine_life');
    String? salvageValue = prefs.getString('salvage_value');
    String? operatorWage = prefs.getString('operator_wage');
    String? consumableCost = prefs.getString('consumable_cost');
    String? factoryRent = prefs.getString('factory_rent');
    String? operatingHours = prefs.getString('operating_hours');
    String? workingDays = prefs.getString("working_days");
    String? depreciation = prefs.getString('depreciation');
    String? powerCosts = prefs.getString('power_costs'); //
    String? operatorWages = prefs.getString('operator_wages'); //
    String? totalCostPerYear = prefs.getString('total_cost_per_year'); //
    String? totalWorkingHours = prefs.getString('total_working_hours');
    String? machineHourRate = prefs.getString('mhr');

    String? powerConsumption = prefs.getString("power_consumption");
    String? powerCost = prefs.getString("power_cost");
    String? fuelCost = prefs.getString("fuel_cost_per_hour");

    debugPrint("Maintenance Cost: $maintenanceCost");
    debugPrint("Machine Purchase Price: $machinePurchasePrice");
    debugPrint("Machine Life: $machineLife");
    debugPrint("Salvage Value: $salvageValue");
    debugPrint("Operator Wage: $operatorWage");
    debugPrint("Consumable Cost: $consumableCost");
    debugPrint("Factory Rent: $factoryRent");
    debugPrint("Operating Hours: $operatingHours");
    debugPrint("Working Days: $workingDays");
    debugPrint("Depreciation: $depreciation");
    debugPrint("Power Costs: $powerCosts");
    debugPrint("Operator Wages: $operatorWages");
    debugPrint("Total Cost Per Year: $totalCostPerYear");
    debugPrint("Total Working Hours: $totalWorkingHours");
    debugPrint("Machine Hour Rate: $machineHourRate");
    debugPrint("Power Consumption: $powerConsumption");
    debugPrint("Power Cost: $powerCost");
    debugPrint("Fuel Cost Per Hour: $fuelCost");

    Map<String, dynamic> requestBody = {
      "main_cat_id": mainCatId,
      "user_id": userId,
      "currency_id": currencyId,
      "currency_amount": currencyAmount,
      "subcat_id": subcatId,
      "maintanance_cost": maintenanceCost,
      "machine_purchase_price": machinePurchasePrice,
      "machine_life": machineLife,
      "salvage_value": salvageValue,
      "operator_wage": operatorWage,
      "consumable_cost": consumableCost,
      "factory_rent": factoryRent,
      "operating_hours": operatingHours,
      "working_days": workingDays,
      "depreciation": depreciation,
      "power_cost": powerCosts,
      "operator_wages": operatorWages,
      "total_cost_per_year": totalCostPerYear,
      "total_working_hours": totalWorkingHours,
      "machine_hour_rate": machineHourRate,
    };
    if (kDebugMode) {
      print(
          'Request Body------------------------------------------: ${json.encode(requestBody)}');
    }

    if (mainCatId == '1') {
      requestBody["power_consumption"] = powerConsumption;
      requestBody["power_cost_per_unit"] = powerCost;
    } else if (mainCatId == '2') {
      requestBody["fuel_cost_per_hour"] = fuelCost;
    }
    if (kDebugMode) {
      print(
          'Request Body------------------------------000000000000000000000: ${json.encode(requestBody)}');
    }
    if (kDebugMode) {
      print("Request Body: $requestBody");
    }
    if (kDebugMode) {
      print(
          'Request Body-----------------------------------1: ${json.encode(requestBody)}');
    }
    try {
      final response = await http.post(
        Uri.parse('http://mhr.sitsolutions.co.in/save_calculation'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Calculation Successfully Saved: ${response.body}");
        }
        if (kDebugMode) {
          print(
              'Request Body--------------------------saved: ${json.encode(requestBody)}');
        } // Log the full request body
        if (context.mounted) {
          onSuccessCallback();
        }
        showTopSnackBar(context, "Calculation saved successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        if (kDebugMode) {
          print(
              "Failed to save calculation: ${response.statusCode} ${response.body}");
        }
        showTopSnackBar(context,
            "Failed to save data. Server returned status: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving calculation: $e");
      }
      showTopSnackBar(context, "Error: $e");
    }
  }

  void showTopSnackBar(
    context,
    String message, {
    bool isSuccess = true,
    Color? color,
    Duration? duration,
  }) {
    final backgroundColor =
        color ?? (isSuccess ? Colors.grey[600] : Colors.red[600]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration ?? const Duration(milliseconds: 1000),
        backgroundColor: Colors.transparent,
        content: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 100,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
