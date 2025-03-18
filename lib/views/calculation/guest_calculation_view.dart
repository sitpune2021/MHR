// ignore_for_file: library_prefixes, deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/db/database_helper.dart';
import 'package:machine_hour_rate/models/mainmachineModel.dart';
import 'package:pie_chart/pie_chart.dart';

class MHRGuestCalculatorsScreen extends StatefulWidget {
  final int viewid;
  MHRGuestCalculatorsScreen({super.key, required this.viewid});

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
  State<MHRGuestCalculatorsScreen> createState() =>
      _MHRGuestCalculatorsScreenState();
}

class _MHRGuestCalculatorsScreenState extends State<MHRGuestCalculatorsScreen> {
  String? machineHourRate;
  get dataMap => null;
  MainMachineModel? selectedMachineId;
  get colorList => null;
  Timer? _timer;
  bool isLoading = true;
  List<Map<String, dynamic>> calculations = [];
  Map<String, dynamic>? currentCalculation;

  @override
  void initState() {
    super.initState();
    fetchCalculation();
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
        fetchCalculation();
      } else {
        timer.cancel();
      }
    });
  }

  void fetchCalculation() async {
    setState(() {
      isLoading = true;
    });
    int calculationId = int.tryParse(widget.viewid.toString()) ?? 2;
    print(calculationId);
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? calculation =
        await dbHelper.getCalculationById(calculationId);

    setState(() {
      currentCalculation = calculation;
      isLoading = false;
    });

    if (calculation == null) {
      print("No calculation found for ID $calculationId");
    }
  }

  Widget buildRow(String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(": ${value ?? 'N/A'}", style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget buildCalculationView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("VIEW",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Text(currentCalculation!["machine_hour_rate"] ?? "N/A",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text("Machine Hour Rate",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  buildRow("Depreciation", currentCalculation!["depreciation"]),
                  buildRow("Power Cost", currentCalculation!["powerCost"]),
                  buildRow(
                      "Operator Wages", currentCalculation!["operatorWages"]),
                  buildRow("Total Cost Per Year",
                      currentCalculation!["totalCostPerYear"]),
                  buildRow("Total Working Hours",
                      currentCalculation!["totalWorkingHours"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                                      "${currentCalculation!["machine_hour_rate"]?.toString()}",
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
                                        ": ${currentCalculation!["depreciation"]?.toString()}",
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
                                        ": ${currentCalculation!["power_cost"]?.toString()}",
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
                                        ": ${currentCalculation!["operator_wages"]?.toString()}",
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
                                        ": ${currentCalculation!["total_cost_per_year"]?.toString()}",
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
                                        ": ${currentCalculation!["total_working_hours"]?.toString()}",
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
                                Text(
                                    ": ${currentCalculation!["maintanance_cost"]}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Machine Purchase Price",
                                    style: TextStyle(fontSize: 16)),
                                Text(
                                    ": ${currentCalculation!["machine_purchase_price"]}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Machine Life",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!["machine_life"]}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Resale Value",
                                    style: TextStyle(fontSize: 16)),
                                Text(
                                    ": ${currentCalculation!["salvage_value"]}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            if (currentCalculation!["main_cat_id"] == '1') ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Power Consumption",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    ": ${currentCalculation!["power_consumption"]}",
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
                                    ": ${currentCalculation!["power_cost_per_unit"]}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                            if (currentCalculation!["main_cat_id"] == '2') ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Fuel Cost",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    ": ${currentCalculation!["fuel_cost_per_hour"]}",
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
                                Text(
                                    ": ${currentCalculation!["operator_wage"]}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Consumable Cost",
                                    style: TextStyle(fontSize: 16)),
                                Text(
                                    ": ${currentCalculation!["consumable_cost"]}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Factory Rent",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!["factory_rent"]}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Operating Hours",
                                    style: TextStyle(fontSize: 16)),
                                Text(
                                    ": ${currentCalculation!["operating_hours"]}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Working Days",
                                    style: TextStyle(fontSize: 16)),
                                Text(": ${currentCalculation!["working_days"]}",
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
                      const Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //pdf download
                                  // ElevatedButton.icon(
                                  //   style: ElevatedButton.styleFrom(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 100.0, vertical: 12.0),
                                  //     backgroundColor: kButtonColor,
                                  //     foregroundColor: Colors.white,
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius:
                                  //           BorderRadius.circular(20.0),
                                  //     ),
                                  //   ),
                                  //   onPressed: () {},
                                  //   //  => _downloadPDF(
                                  //   //     context, currentCalculation),
                                  //   icon: const Icon(Icons.download),
                                  //   label: const Text("Download"),
                                  // ),
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
