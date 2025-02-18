import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGuestUser = false;
  String userName = " ";

  @override
  void initState() {
    super.initState();
    _loadUserStatus();
  }

  Future<void> _loadUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isGuestUser = prefs.getBool("isGuestUser") ?? false;
      userName = isGuestUser
          ? "Guest User"
          : (prefs.getString("userName") ?? "Guest User");
    });
  }

  // Future<void> _loadCalculations() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> savedCalculations = prefs.getStringList("calculations") ?? [];

  //   setState(() {
  //     calculations = savedCalculations
  //         .map((calc) => Map<String, String>.from(jsonDecode(calc)))
  //         .toList();
  //   });
  // }

  // void _openCalculationModal(BuildContext context) async {
  //   bool? isNewCalculation = await showModalBottomSheet<bool>(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => const CalculationSheet(),
  //   );

  //   if (isNewCalculation == true) {
  //     _loadCalculations();
  //   }
  // }

  // String _appVersion = " ";

  // final String _applink =
  //     "https://play.google.com/store/apps/details?id=com.example.myapp";

  // // bool isGuestUser = true;

  Future<bool> getUserLoginStatus() async {
    return Future.value(false); // Replace with actual implementation
  }

  List<Map<String, String>> items = List.generate(
    10,
    (index) =>
        {"title": "Item ${index + 1}", "amount": "\$${(index + 1) * 100}"},
  );

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void editItem(int index) {
    // Implement edit item logic here
    setState(() {
      items[index]["title"] = "Edited Item ${index + 1}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  // "All Calculations (${calculations.length})", dynamic
                  "All Calculations (5)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    " View All",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => {},
                            // editItem(index),
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          // Left side: Item Title
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            items[index]["title"]!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),

                          // Middle: Amount (Centered)
                          Expanded(
                            child: Text(
                              items[index]["amount"]!,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Right side: Close Icon
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => removeItem(index),
                          ),
                        ],
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
}
