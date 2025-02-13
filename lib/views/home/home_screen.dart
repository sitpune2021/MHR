import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
import 'package:machine_hour_rate/views/calculation.dart';
import 'package:machine_hour_rate/views/login/login_screen.dart';
import 'package:machine_hour_rate/views/login/register_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> calculations = [];
  bool isGuestUser = false;
  String userName = " ";

  @override
  void initState() {
    super.initState();
    _loadUserStatus();
    _loadAppVersion();
    _loadCalculations();
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

  Future<void> _loadCalculations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedCalculations = prefs.getStringList("calculations") ?? [];

    setState(() {
      calculations = savedCalculations
          .map((calc) => Map<String, String>.from(jsonDecode(calc)))
          .toList();
    });
  }

  void _openCalculationModal(BuildContext context) async {
    bool? isNewCalculation = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const CalculationSheet(),
    );

    if (isNewCalculation == true) {
      _loadCalculations();
    }
  }

  String _appVersion = " ";

  final String _applink =
      "https://play.google.com/store/apps/details?id=com.example.myapp";

  // bool isGuestUser = true;

  Future<bool> getUserLoginStatus() async {
    return Future.value(false); // Replace with actual implementation
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${packageInfo.version} + ${packageInfo.buildNumber}";
      if (kDebugMode) {
        print("App version: $_appVersion");
      }
    });
  }

  void _shareApp() {
    Share.share("Check out this amazing app: $_applink");
    if (kDebugMode) {
      print("App shared link: $_applink");
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.10,
        // title: const Text("Machine Hour Rate Calculator"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0), // Adjust left padding
          child: _buildHeader(),
        ),
        // leading: _buildHeader(),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == "share") {
                _shareApp();
              } else if (value == "version") {
                _loadAppVersion();
              } else if (value == "logout" && !isGuestUser) {
                _confirmLogout();
              } else if (value == "delete" && !isGuestUser) {
                _confirmDeleteAccount();
              }
            },
            offset: const Offset(0, 40), // Positions the dropdown on the right
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: "share",
                  child: Row(
                    children: [
                      Icon(Icons.share, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("Share the App"),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: "logout",
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 10),
                      Text("Log Out"),
                    ],
                  ),
                ),
                if (!isGuestUser)
                  const PopupMenuItem<String>(
                    value: "delete",
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 10),
                        Text("Delete Account"),
                      ],
                    ),
                  ),
                PopupMenuItem<String>(
                  value: "version",
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.black),
                      const SizedBox(width: 10),
                      Text("App Version: $_appVersion"),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildHeader(),
              // const Divider(thickness: 2, color: Colors.grey),
              const SizedBox(height: 10),
              const Text(
                // "All Calculations (${calculations.length})", dynamic
                "All Calculations (5)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.all(8),
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
                          // Left side: Item Title
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
              )
                  // calculations.isEmpty
                  //     ? const Center(child: Text("No calculations saved"))
                  //     : ListView.builder(
                  //         itemCount: calculations.length,
                  //         itemBuilder: (context, index) {
                  //           return ListTile(
                  //             title: Text(
                  //                 calculations[index]["title"] ?? "Calculation"),
                  //             subtitle: Text(
                  //                 "Result: ${calculations[index]["result"]}"),
                  //           );
                  //         },
                  //       ),
                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.sizeOf(context).height * 0.06,
        child: ElevatedButton(
          onPressed: () => _openCalculationModal(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero, // Remove default padding
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Ink(
            decoration: BoxDecoration(
              color: kButtonColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 24, // Adjust icon height
                    child: Icon(Icons.add,
                        color: Colors.white, size: 24), // Set icon size
                  ),
                  SizedBox(width: 8),
                  Text(
                    "NEW CALCULATION",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: GestureDetector(
        onTap: isGuestUser ? null : () => _showProfileDetails(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            const SizedBox(width: 10),
            Text(
              userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileDetails(BuildContext context) {
    if (isGuestUser = false) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profile Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/logo.png'),
              ),
              const SizedBox(height: 20),
              Text('Name : $userName'),
              const Text('Email : johndoe@example.com'),
              const Text('Mobile : +1234567890'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _logout() {
    if (kDebugMode) {
      print("User logged out");
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    if (kDebugMode) {
      print("User account deleted");
    }
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }
}
