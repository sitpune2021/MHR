// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machine_hour_rate/providers/auth_provider.dart';
import 'package:machine_hour_rate/views/login/login_screen.dart';
import 'package:machine_hour_rate/views/login/register_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final bool isGuestUser;

  const SettingsPage({super.key, required this.isGuestUser});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String email = "";
  String mobile = "";
  String name = "";
  String _appVersion = " ";

  File? _image;

  final String _applink =
      "https://play.google.com/store/apps/details?id=com.example.myapp";

  bool isGuestUser = true;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _loadUserStatus();
    _loadSavedImage();
  }

  Future<void> _loadUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isGuestUser = prefs.getBool("isLoggedGuestUser") ?? false;
      if (isGuestUser) {
        name = "Guest User";
        email = "";
        mobile = "";
      } else {
        name = prefs.getString("user_name") ?? " ";
        email = prefs.getString("user_email") ?? "";
        mobile = prefs.getString("user_mobile") ?? "";
      }
    });
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${packageInfo.version} ";
      if (kDebugMode) {
        print("App version: $_appVersion");
      }
    });
  }

  void _shareApp() {
    FocusScope.of(context).unfocus();
    Share.share("Check out this amazing app: $_applink");
    if (kDebugMode) {
      print("App shared link: $_applink");
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Log Out",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to log out?",
            style: TextStyle(fontSize: 18, color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.blue, fontSize: 18)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text("Log Out",
                style: TextStyle(color: Colors.green, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    if (kDebugMode) {
      print("User logged out");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.clear();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Delete Account",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
            style: TextStyle(fontSize: 18, color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.blue, fontSize: 18)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text("Delete",
                style: TextStyle(color: Colors.red, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() async {
    if (kDebugMode) {
      print("User account deleted");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // await _removeImage();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }

  // stored image
  Future<void> _loadSavedImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString('profile_image');
    if (savedImagePath != null) {
      setState(() {
        _image = File(savedImagePath);
      });
    }
  }

  Future<void> _pickImage({bool fromCamera = false}) async {
    PermissionStatus status;

    if (fromCamera) {
      status = await Permission.camera.request();
    } else {
      if (Platform.isAndroid) {
        status = await Permission.photos.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          status = await Permission.storage.request();
        }
      } else {
        status = await Permission.photos.request();
      }
    }

    if (status.isGranted) {
      final pickedFile = await ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        _saveImagePath(pickedFile.path);
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Permission denied. Cannot access photos.")),
      );
    }
  }

  // Save the selected image
  Future<void> _saveImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
  }

  // Remove stored image path
  Future<void> _removeImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image');
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.userData;

    String displayName =
        isGuestUser ? "Guest User" : user?.name ?? "Guest User";
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(06.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 6, right: 6, bottom: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[300],
                                backgroundImage:
                                    _image != null ? FileImage(_image!) : null,
                                child: _image == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.blue,
                                      )
                                    : null,
                              ),
                              if (_image != null)
                                Positioned(
                                  top: 5,
                                  right: 0.1,
                                  child: GestureDetector(
                                    onTap: _removeImage,
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              // Positioned(
                              //   bottom: 5,
                              //   right: 0.1,
                              //   child: GestureDetector(
                              //     onTap: _pickImage,
                              //     child: const CircleAvatar(
                              //       radius: 12,
                              //       backgroundColor: Colors.blue,
                              //       child: Icon(
                              //         Icons.camera_alt,
                              //         color: Colors.white,
                              //         size: 18,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Name : ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  displayName,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (!isGuestUser) ...[
                            if (user?.email != null && user!.email!.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Email : ",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "${user.email}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                          const SizedBox(height: 2),
                          if (!isGuestUser) ...[
                            if (user?.mobile != null &&
                                user!.mobile!.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Mobile : ",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                    Text(
                                      "${user.mobile}",
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
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
                            const Divider(
                                thickness: 1, indent: 20, endIndent: 20),
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
                            const Divider(
                                thickness: 1, indent: 20, endIndent: 20),
                            InkWell(
                              onTap: _confirmLogout,
                              child: const ListTile(
                                leading: Icon(Icons.login, color: Colors.blue),
                                title: Text("Log Out",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            if (!isGuestUser) ...[
                              const Divider(
                                  thickness: 1, indent: 20, endIndent: 20),
                              InkWell(
                                onTap: _confirmDeleteAccount,
                                child: const ListTile(
                                  leading:
                                      Icon(Icons.delete, color: Colors.blue),
                                  title: Text("Delete Account",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                            const Divider(
                                thickness: 1, indent: 20, endIndent: 20),
                            InkWell(
                              child: ListTile(
                                leading:
                                    const Icon(Icons.info, color: Colors.blue),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("App Version",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("V $_appVersion",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
