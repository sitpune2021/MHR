// ignore_for_file: library_prefixes

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';
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

  get colorList => null;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _saveData() async {
    try {
      if (machineHourRate == null || machineHourRate!.isEmpty) {
        _showMessage("Machine Hour Rate is empty!");
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("machineHourRate", machineHourRate!);
      _showMessage("Data Saved Successfully");
    } catch (e) {
      _showMessage("Error saving data: \$e");
    }
  }

  Future<void> _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        machineHourRate = prefs.getString("machineHourRate") ?? "\$125.50 / hr";
      });
    } catch (e) {
      _showMessage("Error loading data: \$e");
    }
  }

  Future<void> _downloadPDF() async {
    try {
      if (machineHourRate == null || machineHourRate!.isEmpty) {
        _showMessage("Machine Hour Rate is empty!");
        return;
      }

      final pdf = pdfLib.Document();
      pdf.addPage(
        pdfLib.Page(
          build: (pdfLib.Context context) => pdfLib.Center(
            child: pdfLib.Text("Machine Hour Rate: \$machineHourRate"),
          ),
        ),
      );

      var status = await Permission.storage.request();
      if (status.isGranted) {
        final directory = await getExternalStorageDirectory();
        if (directory == null) {
          throw Exception("Failed to get storage directory");
        }
        final file = File("${directory.path}/MHR_Report.pdf");
        await file.writeAsBytes(await pdf.save());
        _showMessage("PDF Downloaded Successfully");
      } else {
        _showMessage("Storage permission denied!");
      }
    } catch (e) {
      _showMessage("Error generating PDF: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("VIEW",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

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
              // const Text("RESULT",
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Metalworking Machine",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(left: 100, right: 100, top: 16),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(machineHourRate ?? "Loading...",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text("Machine Hour Rate",
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.only(left: 100, right: 100, top: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Operational Hours : 2 ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Maintenance Cost : 2",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Energy Cost : 2",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                thickness: 2,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              const Text(
                "Your Input ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.only(left: 100, right: 100, top: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Power Consumption : 2",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Labour cost : 2",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Maintenance Expense : 2",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: _saveData,
                        icon: const Icon(Icons.save),
                        label: const Text("Delete"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                          backgroundColor: kButtonColor,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: _downloadPDF,
                        icon: const Icon(Icons.download),
                        label: const Text("DOWNLOAD PDF"),
                      ),
                    ]),
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 20.0, vertical: 12.0),
              //       backgroundColor: Colors.red,
              //       foregroundColor: Colors.black87,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //     onPressed: _saveData,
              //     icon: const Icon(Icons.save),
              //     label: const Text("Delete"),
              //   ),
              // ),
              // const SizedBox(height: 12),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 20.0, vertical: 12.0),
              //       backgroundColor: kButtonColor,
              //       foregroundColor: Colors.black87,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //     onPressed: _downloadPDF,
              //     icon: const Icon(Icons.download),
              //     label: const Text("DOWNLOAD PDF"),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
