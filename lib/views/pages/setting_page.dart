// import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine_hour_rate/views/login/login_screen.dart';
import 'package:machine_hour_rate/views/login/register_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatefulWidget {
  final bool isGuestUser;

  const SettingsPage({super.key, required this.isGuestUser});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = " ";

  final String _applink =
      "https://play.google.com/store/apps/details?id=com.example.myapp";

  bool isGuestUser = true;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _loadUserStatus();
  }

  Future<void> _loadUserStatus() async {
    bool status = await getUserLoginStatus();
    setState(() {
      isGuestUser = status;
    });
  }

  Future<bool> getUserLoginStatus() async {
    // Implement your logic to get the user login status here
    // For example, return true if the user is logged in, otherwise false
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "User Name",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Email: user@example.com",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Mobile: +91 9876543210",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _shareApp,
                        child: const ListTile(
                          leading: Icon(Icons.share, color: Colors.blue),
                          title: Text("Share the App",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const Divider(thickness: 1, indent: 20, endIndent: 20),
                      InkWell(
                        onTap: _shareApp,
                        child: const ListTile(
                          leading: Icon(Icons.star, color: Colors.blue),
                          title: Text("Rate the App",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      !widget.isGuestUser == false
                          ? const Divider(
                              thickness: 1,
                              indent: 2,
                              endIndent: 2,
                            )
                          : Container(),
                      !widget.isGuestUser == false
                          ? InkWell(
                              onTap: _confirmLogout,
                              child: const ListTile(
                                leading: Icon(Icons.login, color: Colors.blue),
                                title: Text("Log Out",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          : Container(),
                      !widget.isGuestUser == false
                          ? const Divider(
                              thickness: 1,
                              indent: 2,
                              endIndent: 2,
                            )
                          : Container(),
                      !widget.isGuestUser == false
                          ? InkWell(
                              onTap: _confirmDeleteAccount,
                              child: const ListTile(
                                leading: Icon(Icons.delete, color: Colors.blue),
                                title: Text("Delete Account",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          : Container(),
                      const Divider(thickness: 1, indent: 20, endIndent: 20),
                      InkWell(
                        onTap: _shareApp,
                        child: ListTile(
                          leading: const Icon(Icons.info, color: Colors.blue),
                          title: Text("App Version $_appVersion",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
