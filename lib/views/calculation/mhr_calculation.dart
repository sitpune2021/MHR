// ignore_for_file: library_prefixes, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
import 'package:machine_hour_rate/models/calculationModel.dart';
import 'package:machine_hour_rate/models/mainmachineModel.dart';
import 'package:machine_hour_rate/providers/calculationprovider.dart';
import 'package:machine_hour_rate/views/home/home_page_view.dart';
import 'package:machine_hour_rate/views/home/home_screen.dart';
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
  String? mhr;
  MainMachineModel? selectedMachineId;
  Map<String, dynamic> storedValues = {};

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
        "depreciation": prefs.getString("depreciation"),
        "power_costs": prefs.getString("power_costs"),
        "operator_wages": prefs.getString("operator_wages"),
        "total_cost_per_year": prefs.getString("total_cost_per_year"),
        "total_working_hours": prefs.getString("total_working_hours"),
      };
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _downloadPDF(BuildContext context, dynamic result) async {
    final provider = Provider.of<CalculationProvider>(context, listen: false);
    final result = provider.calculationResult;
    try {
      if (result?.mhr == null || result!.mhr!.isEmpty) {
        _showMessage("Machine Hour Rate is empty!");
        return;
      }

      // Request Storage Permission
      bool hasPermission = await _requestStoragePermission(context);
      if (!hasPermission) {
        _showMessage("Storage permission denied!");
        return;
      }

      // Generate the PDF
      final pdf = pdfLib.Document();
      pdf.addPage(
        pdfLib.Page(
          build: (pdfLib.Context context) => pdfLib.Center(
            child: pdfLib.Column(
              children: [
                pdfLib.Text("Machine Hour Rate Report",
                    style: const pdfLib.TextStyle(fontSize: 24)),
                pdfLib.SizedBox(height: 20),
                pdfLib.Text("Machine Hour Rate: ${result.mhr ?? 'N/A'}"),
                pdfLib.Text("Depreciation: ${result.depreciation ?? '0'}"),
                pdfLib.Text("Power Cost: ${result.powerCost ?? '0'}"),
                pdfLib.Text("Operator Wages: ${result.operatorWages ?? '0'}"),
                pdfLib.Text(
                    "Total Cost Per Year: ${result.totalCostPerYear ?? '0'}"),
                pdfLib.Text(
                    "Total Working Hours: ${result.totalWorkingHours ?? '0'}"),
                pdfLib.SizedBox(height: 20),
                pdfLib.Text("Your Input Values:",
                    style: const pdfLib.TextStyle(fontSize: 20)),
                pdfLib.Text(
                    "Maintenance Cost: ${storedValues['maintanance_cost'] ?? '0'}"),
                pdfLib.Text(
                    "Machine Purchase Price: ${storedValues['machine_purchase_price'] ?? '0'}"),
                pdfLib.Text(
                    "Machine Life: ${storedValues['machine_life'] ?? '0'}"),
                pdfLib.Text(
                    "Salvage Value: ${storedValues['salvage_value'] ?? '0'}"),
                pdfLib.Text(
                    "Power Consumption: ${storedValues['power_consumption'] ?? '0'}"),
                pdfLib.Text(
                    "Fuel Cost: ${storedValues['fuel_cost_per_hour'] ?? '0'}"),
                pdfLib.Text(
                    "Operator Wage: ${storedValues['operator_wage'] ?? '0'}"),
                pdfLib.Text(
                    "Consumable Cost: ${storedValues['consumable_cost'] ?? '0'}"),
                pdfLib.Text(
                    "Factory Rent: ${storedValues['factory_rent'] ?? '0'}"),
                pdfLib.Text(
                    "Operating Hours: ${storedValues['operating_hours'] ?? '0'}"),
                pdfLib.Text(
                    "Working Days: ${storedValues['working_days'] ?? '0'}"),
              ],
            ),
            // child: pdfLib.Text("Machine Hour Rate: $mhr",
            //     style: const pdfLib.TextStyle(fontSize: 20)),
          ),
        ),
      );

      // Let the user choose a directory
      String? selectedDirectory = await _pickDirectory();
      if (selectedDirectory == null) {
        _showMessage("No folder selected!");
        return;
      }

      await _savePDF(context, pdf, selectedDirectory);
    } catch (e) {
      _showMessage("Error generating PDF: $e");
    }
  }

  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();

      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        _showMessage(
            "Storage permission is permanently denied. Enable it in settings.");
        openAppSettings();
      }

      return false;
    }
    return true;
  }

  Future<String?> _pickDirectory() async {
    try {
      return await FilePicker.platform.getDirectoryPath();
    } catch (e) {
      debugPrint("Error picking directory: $e");
      return null;
    }
  }

  Future<void> _savePDF(
      BuildContext context, pdfLib.Document pdf, String directoryPath) async {
    try {
      // Ensure the directory exists
      final directory = Directory(directoryPath);
      if (!(await directory.exists())) {
        await directory.create(recursive: true); // Create if it doesn't exist
      }
      String filePath = "$directoryPath/MHR_Report.pdf";
      File file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      _showMessage("PDF Downloaded Successfully: $filePath");
    } catch (e) {
      _showMessage("Error saving PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculationProvider>(context);
    final result = provider.calculationResult;

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text("VIEW",
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 250,
                  width: 280,
                  child: PieChart(
                    dataMap: widget.dataMap,
                    animationDuration: const Duration(milliseconds: 800),
                    chartType: ChartType.ring,
                    colorList: widget.colorList,
                    legendOptions: const LegendOptions(showLegends: true),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                  ),
                ),
                // Display calculation results if available
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result?.mhr?.toString() ?? 'N/A',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const Text("Machine Hour Rate",
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Display detailed breakdown of costs
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Depreciation: ${result?.depreciation ?? 'N/A'}"),
                      Text("Power Cost: ${result?.powerCost ?? 'N/A'}"),
                      Text("Operator Wages: ${result?.operatorWages ?? 'N/A'}"),
                      Text(
                          "Total Cost Per Year: ${result?.totalCostPerYear ?? 'N/A'}"),
                      Text(
                          "Total Working Hours: ${result?.totalWorkingHours ?? 'N/A'}"),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Divider(thickness: 2, color: Colors.grey),
                const SizedBox(height: 5),
                const Text(
                  "Your Input ",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Display stored input values
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Maintenance Cost: ${storedValues['maintanance_cost'] ?? 'N/A'}"),
                      Text(
                          "Machine Purchase Price: ${storedValues['machine_purchase_price'] ?? 'N/A'}"),
                      Text(
                          "Machine Life: ${storedValues['machine_life'] ?? 'N/A'}"),
                      Text(
                          "Salvage Value: ${storedValues['salvage_value'] ?? 'N/A'}"),
                      if (storedValues['main_cat_id'] == '1') ...[
                        Text(
                            "Power Consumption: ${storedValues['power_consumption'] ?? 'N/A'}"),
                        Text(
                            "Power Cost: ${storedValues['power_cost'] ?? 'N/A'}"),
                      ],
                      if (storedValues['main_cat_id'] == '2') ...[
                        Text(
                            "Fuel Cost: ${storedValues['fuel_cost_per_hour'] ?? 'N/A'}"),
                      ],
                      Text(
                          "Operator Wage: ${storedValues['operator_wage'] ?? 'N/A'}"),
                      Text(
                          "Consumable Cost: ${storedValues['consumable_cost'] ?? 'N/A'}"),
                      Text(
                          "Factory Rent: ${storedValues['factory_rent'] ?? 'N/A'}"),
                      Text(
                          "Operating Hours: ${storedValues['operating_hours'] ?? 'N/A'}"),
                      Text(
                          "Working Days: ${storedValues['working_days'] ?? 'N/A'}"),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        // Fixed bottom buttons
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Save Calculation Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kButtonColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await SaveCalculation(() {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                  }).saveData(context);
                },
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              ),
              // Download PDF Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kButtonColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _downloadPDF(context, storedValues),
                icon: const Icon(Icons.download),
                label: const Text("Download"),
              ),
            ],
          ),
        ),
      ),
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

    // Create the request body
    Map<String, dynamic> requestBody = {
      "main_cat_id": mainCatId,
      "user_id": 10, // Ensure this is the actual user id
      "currency_id": currencyId,
      "currency_amount": currencyAmount,
      "subcat_id": subcatId, // Assuming it might be used

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
    print(
        'Request Body------------------------------------------: ${json.encode(requestBody)}'); // Log the full request body
    // If category specific data is needed
    if (mainCatId == '1') {
      requestBody["power_consumption"] = powerConsumption;
      requestBody["power_cost_per_unit"] = powerCost;
    } else if (mainCatId == '2') {
      requestBody["fuel_cost_per_hour"] = fuelCost;
    }
    print(
        'Request Body------------------------------000000000000000000000: ${json.encode(requestBody)}'); // Log the full request body
    // Print the request body for debugging
    if (kDebugMode) {
      print("Request Body: $requestBody");
    }
    print(
        'Request Body-----------------------------------1: ${json.encode(requestBody)}'); // Log the full request body
    try {
      final response = await http.post(
        Uri.parse('http://mhr.sitsolutions.co.in/save_calculation'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Handle success response
        if (kDebugMode) {
          print("Calculation Successfully Saved: ${response.body}");
        }
        print(
            'Request Body--------------------------2: ${json.encode(requestBody)}'); // Log the full request body
        onSuccessCallback();
        showTopSnackBar(context, "Calculation saved successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Handle the failure response
        if (kDebugMode) {
          print(
              "Failed to save calculation: ${response.statusCode} ${response.body}");
        }
        showTopSnackBar(context,
            "Failed to save data. Server returned status: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exception
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
