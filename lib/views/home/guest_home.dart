import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/views/calculation/guest_calculation_view.dart';
import '../../core/db/database_helper.dart';

class GuestHome extends StatefulWidget {
  const GuestHome({super.key});

  @override
  State<GuestHome> createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> {
  List<Map<String, dynamic>> calculations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCalculations();
  }

  Future<void> _fetchCalculations() async {
    final dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> data = await dbHelper.getCalculations();

    setState(() {
      calculations = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : calculations.isEmpty
                      ? const Center(child: Text("No data available"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: calculations.length,
                          itemBuilder: (context, index) {
                            final calculation = calculations[index];
                            final calId = calculations[index]["id"];

                            return GestureDetector(
                              onTap: () {
                                print(
                                    "-------------------calcution id-----------$calId");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MHRGuestCalculatorsScreen(
                                            viewid: calId ?? "",
                                          )),
                                );
                              },
                              child: Card(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // IconButton(
                                      //   icon: const Icon(Icons.edit,
                                      //       color: Colors.blue),
                                      //   onPressed: () {},
                                      // ),
                                      const Text(
                                        "Calculation",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${calculation['currency_id'] == '3' ? "€" : calculation['currency_id'] == '2' ? "\$" : calculation['currency_id'] == '1' ? '₹' : ''} ${calculation['machine_hour_rate']}",
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
                                          if (kDebugMode) {
                                            print(
                                                "---------------------------${calculation['id']}");
                                          }
                                          _deleteCalculation(calculation['id']);
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

  Future<void> _deleteCalculation(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteCalculation(id);
    _fetchCalculations();
  }
}
