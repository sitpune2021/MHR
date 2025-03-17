// ignore_for_file: library_prefixes, deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
import 'package:machine_hour_rate/models/calculationlistModel.dart';
import 'package:machine_hour_rate/models/mainmachineModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_filex/open_filex.dart';

class MHRCalculatorsScreen extends StatefulWidget {
  final String viewid;
  MHRCalculatorsScreen({super.key, required this.viewid});

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
  State<MHRCalculatorsScreen> createState() => _MHRCalculatorsScreenState();
}

class _MHRCalculatorsScreenState extends State<MHRCalculatorsScreen> {
  String? machineHourRate;
  get dataMap => null;
  MainMachineModel? selectedMachineId;
  get colorList => null;
  Timer? _timer;
  CalculationListModel? currentCalculation;
  bool isLoading = true;
  List<CalculationListModel> calculationss = [];

  @override
  void initState() {
    super.initState();
    fetchCalculationsView();
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
        fetchCalculationsView();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> fetchCalculationsView({String? userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("http://mhr.sitsolutions.co.in/view_calculation");
    var userid = prefs.getString("user_id");

    print("--------------------------------------viewid ${widget.viewid}");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userid,
          "id": widget.viewid,
        }),
      );

      if (kDebugMode) {
        print("Fetch Response Status Code: ${response.statusCode}");
      }
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData["status"] == "success") {
          Map<String, dynamic> details =
              jsonData["details"]; // FIXED: Use Map instead of List

          print("--------------Calculation view data-----------$jsonData");
          print("--------------Calculation details-----------$details");

          CalculationListModel fetchedCalculation =
              CalculationListModel.fromJson(details);

          if (mounted) {
            setState(() {
              calculationss = [fetchedCalculation]; // Wrap in a list if needed
              isLoading = false;
              currentCalculation = fetchedCalculation;
            });

            if (kDebugMode) {
              print("Updated calculations count: ${calculationss.length}");
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
          isLoading = false; // Stop loading
        });
      }
      if (kDebugMode) {
        print("Error fetching calculations: $e");
      }
    }
  }

  // Future<void> _downloadPDF(BuildContext context, dynamic result) async {
  //   if (currentCalculation!.machineHourRate == null ||
  //       currentCalculation!.machineHourRate!.isEmpty) {
  //     _showMessage(context, "Machine Hour Rate is empty!");
  //     return;
  //   }

  //   if (!await _requestStoragePermission()) {
  //     return; // Permission denied
  //   }

  //   // Get external storage directory (Scoped Storage)
  //   Directory? directory = await getExternalStorageDirectory();
  //   if (directory == null) {
  //     _showMessage(context, "Unable to find storage directory!");
  //     return;
  //   }

  //   // Use Downloads directory instead
  //   String documentsPath =
  //       "/storage/emulated/0/Download"; // Standard Downloads folder
  //   String filePath = "$documentsPath/machine_hour_rate.pdf";

  //   final pdf = pdfLib.Document();
  //   pdf.addPage(
  //     pdfLib.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (pdfLib.Context context) => pdfLib.Center(
  //         child: pdfLib.Column(
  //           mainAxisAlignment: pdfLib.MainAxisAlignment.start,
  //           children: [
  //             pdfLib.Text("Machine Hour Rate Overview",
  //                 style: const pdfLib.TextStyle(fontSize: 24)),
  //             pdfLib.SizedBox(height: 20),
  //             pdfLib.Text("Calculation Result",
  //                 style: const pdfLib.TextStyle(fontSize: 24)),
  //             pdfLib.SizedBox(height: 10),
  //             //calculation
  //             pdfLib.Text(
  //                 "Machine Hour Rate: ${currentCalculation!.machineHourRate}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text("Depreciation: ${currentCalculation!.depreciation}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text("Power Cost: ${currentCalculation!.powerCost}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text(
  //                 "Operator Wages: ${currentCalculation!.operatorWages}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text(
  //                 "Total Cost Per Year: ${currentCalculation!.totalCostPerYear}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text(
  //                 "Total Working Hours: ${currentCalculation!.totalWorkingHours}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.SizedBox(height: 20),
  //             // inpute
  //             pdfLib.Text("Calculation User Input Values",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.SizedBox(height: 10),
  //             pdfLib.Text(
  //                 "Maintenance Cost: ${currentCalculation!.maintananceCost}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text(
  //                 "Machine Purchase Price: ${currentCalculation!.machinePurchasePrice}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text("Machine Life: ${currentCalculation!.machineLife}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text("Salvage Value: ${currentCalculation!.salvageValue}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text(
  //                 "Power Consumption: ${currentCalculation!.powerConsumption ?? '0'}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text(
  //                 "Power Cost: ${currentCalculation!.powerCostPerUnit ?? '0'}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text(
  //                 "Fuel Cost: ${currentCalculation!.fuelCostPerHour ?? '0'} ",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text("Operator Wage: ${currentCalculation!.operatorWage}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text(
  //                 "Consumable Cost: ${currentCalculation!.consumableCost}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text("Factory Rent: ${currentCalculation!.factoryRent}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text(
  //                 "Operating Hours: ${currentCalculation!.operatingHours}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.Text("Working Days: ${currentCalculation!.workingDays}",
  //                 style: const pdfLib.TextStyle(fontSize: 20)),
  //             pdfLib.SizedBox(height: 10),
  //             pdfLib.Text("Generated on: ${DateTime.now()}"),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );

  //   await _savePDF(
  //     context,
  //     pdf,
  //   );
  // }
  Future<void> _downloadPDF(BuildContext context, dynamic result) async {
    if (currentCalculation!.machineHourRate == null ||
        currentCalculation!.machineHourRate!.isEmpty) {
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
              pdfLib.Text("Calculation Result",
                  style: const pdfLib.TextStyle(fontSize: 24)),
              pdfLib.SizedBox(height: 10),

              // Calculation fields (only show if not null)
              pdfLib.Text(
                  "Machine Hour Rate: ${currentCalculation!.machineHourRate}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Depreciation: ${currentCalculation!.depreciation}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Power Cost: ${currentCalculation!.powerCost}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text(
                  "Operator Wages: ${currentCalculation!.operatorWages}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text(
                  "Total Cost Per Year: ${currentCalculation!.totalCostPerYear}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text(
                  "Total Working Hours: ${currentCalculation!.totalWorkingHours}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.SizedBox(height: 20),

              // Input values section
              pdfLib.Text("Calculation User Input Values",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.SizedBox(height: 10),
              pdfLib.Text(
                  "Maintenance Cost: ${currentCalculation!.maintananceCost}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text(
                  "Machine Purchase Price: ${currentCalculation!.machinePurchasePrice}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Machine Life: ${currentCalculation!.machineLife}",
                  style: const pdfLib.TextStyle(fontSize: 20)),

              pdfLib.Text("Salvage Value: ${currentCalculation!.salvageValue}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              if (currentCalculation != null &&
                  currentCalculation!.mainCatId == '1') ...[
                pdfLib.Text(
                    "Power Consumption: ${currentCalculation!.powerConsumption}",
                    style: const pdfLib.TextStyle(fontSize: 20)),
                pdfLib.Text(
                    "Power Cost: ${currentCalculation!.powerCostPerUnit}",
                    style: const pdfLib.TextStyle(fontSize: 20)),
              ],
              if (currentCalculation!.mainCatId == '2') ...[
                pdfLib.Text("Fuel Cost: ${currentCalculation!.fuelCostPerHour}",
                    style: const pdfLib.TextStyle(fontSize: 20)),
              ],
              pdfLib.Text("Operator Wage: ${currentCalculation!.operatorWage}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text(
                  "Consumable Cost: ${currentCalculation!.consumableCost}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Factory Rent: ${currentCalculation!.factoryRent}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text(
                  "Operating Hours: ${currentCalculation!.operatingHours}",
                  style: const pdfLib.TextStyle(fontSize: 20)),
              pdfLib.Text("Working Days: ${currentCalculation!.workingDays}",
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
      print("PDF saved at $filePath");

      // Open the file after saving
      OpenFilex.open(filePath);
    } catch (e) {
      _showMessage(context, "Failed to save PDF: $e");
      print("Download failed: $e");
    }
  }

  // Future<bool> _requestStoragePermission() async {
  //   if (Platform.isAndroid) {
  //     // For Android 10 and below
  //     var status = await Permission.storage.status;
  //     if (!status.isGranted) {
  //       status = await Permission.storage.request();
  //     }

  //     // For Android 11 and above
  //     if (await Permission.manageExternalStorage.isGranted) {
  //       return true;
  //     } else {
  //       var status = await Permission.manageExternalStorage.request();
  //       return status.isGranted;
  //     }
  //   }
  //   return true; // For non-Android platforms
  // }
  // Future<bool> _requestStoragePermission() async {
  //   if (Platform.isAndroid) {
  //     // Check if storage permissions are granted
  //     var status = await Permission.storage.status;
  //     if (!status.isGranted) {
  //       status = await Permission.storage.request();
  //       if (!status.isGranted) {
  //         return false; // If permission is denied, return false
  //       }
  //     }

  //     // For Android 11 and above, handle the manage external storage permission
  //     if (Platform.version.startsWith('10')) {
  //       var manageStatus = await Permission.manageExternalStorage.status;
  //       if (!manageStatus.isGranted) {
  //         manageStatus = await Permission.manageExternalStorage.request();
  //         return manageStatus
  //             .isGranted; // Return whether permission was granted
  //       }
  //     }
  //     return true; // Permission is granted
  //   }
  //   return true; // Non-Android platforms don't need this
  // }

  // Future<bool> _requestStoragePermission() async {
  //   if (Platform.isAndroid) {
  //     // Check if storage permissions are granted
  //     var status = await Permission.storage.status;
  //     if (!status.isGranted) {
  //       status = await Permission.storage.request();
  //       if (!status.isGranted) {
  //         return false; // If permission is denied, return false
  //       }
  //     }
  //     return true; // Permission is granted
  //   }
  //   return true; // Non-Android platforms don't need this
  // }
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
        body: isLoading
            ? const Center()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("VIEW",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 200,
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
                      (currentCalculation != null)
                          ? Container(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "${currentCalculation!.machineHourRate?.toString()}",
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  const Text(
                                    "Machine Hour Rate",
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 6),
                      (currentCalculation != null)
                          ? Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
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
                                        ": ${currentCalculation!.depreciation?.toString()}",
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
                                        ": ${currentCalculation!.powerCost?.toString()}",
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
                                        ": ${currentCalculation!.operatorWages?.toString()}",
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
                                        ": ${currentCalculation!.totalCostPerYear?.toString()}",
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
                                        ": ${currentCalculation!.totalWorkingHours?.toString()}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
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
                            left: 20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Maintenance Cost",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!.maintananceCost}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Machine Purchase Price",
                                    style: TextStyle(fontSize: 16)),
                                Text(
                                    ": ${currentCalculation!.machinePurchasePrice}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Machine Life",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!.machineLife}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Salvage Value",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!.salvageValue}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            if (currentCalculation!.mainCatId == '1') ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Power Consumption",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    ": ${currentCalculation!.powerConsumption}",
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
                                    ": ${currentCalculation!.powerCostPerUnit}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                            if (currentCalculation!.mainCatId == '2') ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Fuel Cost",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    ": ${currentCalculation!.fuelCostPerHour}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Operator Wage",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!.operatorWage}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Consumable Cost",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!.consumableCost}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Factory Rent",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!.factoryRent}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Operating Hours",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!.operatingHours}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Working Days",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!.workingDays}",
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
                                  //pdf download
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 100.0, vertical: 12.0),
                                      backgroundColor: kButtonColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: () => _downloadPDF(
                                        context, currentCalculation),
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
    );
  }
}
