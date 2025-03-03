// ignore_for_file: library_prefixes, deprecated_member_use

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
import 'package:machine_hour_rate/models/calculationModel.dart';
import 'package:machine_hour_rate/models/mainmachineModel.dart';
import 'package:machine_hour_rate/providers/calculationprovider.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MHRCalScreen extends StatefulWidget {
  MHRCalScreen({super.key});

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
  State<MHRCalScreen> createState() => _MHRCalScreennState();
}

class _MHRCalScreennState extends State<MHRCalScreen> {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No calculation result found.")));
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
        "depreciation": prefs.getString("depreciation"),
        "power_costs": prefs.getString("power_costs"),
        "operator_wages": prefs.getString("operator_wages"),
        "total_cost_per_year": prefs.getString("total_cost_per_year"),
        "total_working_hours": prefs.getString("total_working_hours"),
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

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

//pdf
  Future<void> _downloadPDF(BuildContext context, dynamic result) async {
    try {
      if (result.mhr == null || result.mhr!.isEmpty) {
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
            child: pdfLib.Text("Machine Hour Rate: $machineHourRate",
                style: const pdfLib.TextStyle(fontSize: 20)),
          ),
        ),
      );

      // Let user choose directory
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

// Request Storage Permission
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

// Let user pick a directory
  Future<String?> _pickDirectory() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.getDirectoryPath() as FilePickerResult?;
      return result?.paths.first; // Ensure correct type conversion
    } catch (e) {
      debugPrint("Error picking directory: $e");
      return null;
    }
  }

// Save PDF in selected directory
  Future<void> _savePDF(
      BuildContext context, pdfLib.Document pdf, String directoryPath) async {
    try {
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
        body: result == null
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Center(
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
                        const Text("UPDATE REPORT",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 250,
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
                              left: 100, right: 100, top: 16),
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(result.mhr?.toString() ?? 'N/A',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              const Text("Machine Hour Rate",
                                  style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 100, right: 100, top: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Depreciation: ${result.depreciation?.toString() ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Power Cost: ${result.powerCost?.toString() ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Operator Wages: ${result.operatorWages?.toString() ?? 'N/A'}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Total Cost Per Year: ${result.totalCostPerYear?.toString() ?? 'N/A'}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Total Working Hours: ${result.totalWorkingHours?.toString() ?? 'N/A'}",
                                style: const TextStyle(fontSize: 16),
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
                              left: 100, right: 100, top: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Maintenance Cost: ${storedValues['maintanance_cost']}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Machine Purchase Price: ${storedValues['machine_purchase_price']}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Machine Life: ${storedValues['machine_life']}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Salvage Value: ${storedValues['salvage_value']}",
                                  style: const TextStyle(fontSize: 16)),
                              if (storedValues['main_cat_id'] == '1') ...[
                                Text(
                                  "Power Consumption: ${storedValues['power_consumption'] ?? 'N/A'}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Power Cost: ${storedValues['power_cost'] ?? 'N/A'}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                              if (storedValues['main_cat_id'] == '2') ...[
                                Text(
                                  "Fuel Cost: ${storedValues['fuel_cost_per_hour'] ?? 'N/A'}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                              Text(
                                  "Operator Wage: ${storedValues['operator_wage']}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Consumable Cost: ${storedValues['consumable_cost']}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Factory Rent: ${storedValues['factory_rent']}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Operating Hours: ${storedValues['operating_hours']}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Working Days: ${storedValues['working_days']}",
                                  style: const TextStyle(fontSize: 16)),
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
                                    //pdf download
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 12.0),
                                        backgroundColor: kButtonColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                ),
              ),
      ),
    );
  }
}
