import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:machine_hour_rate/providers/auth_provider.dart';
import 'package:machine_hour_rate/views/home/home_page_view.dart';
import 'package:machine_hour_rate/views/login/login_screen.dart';
import 'package:machine_hour_rate/views/login/verification_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isPrivacyChecked = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final validationErrors = authProvider.validationErrors;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        SingleChildScrollView(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Create Account', style: TextStyle(fontSize: 34)),
                  ],
                ),
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Sign Up To Continue', style: TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(height: 10),
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/logo.png"),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _firstNameController,
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.blue,
                  cursorErrorColor: Colors.blue,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.yellowAccent),
                    ),
                    labelText: "First Name",
                    labelStyle: const TextStyle(color: Colors.black),
                    // hintText: "Enter your first name",
                    errorText: validationErrors?['firstName'],
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your first name.';
                    }
                    final RegExp nameRegExp = RegExp(r'^[a-zA-Z]+$');
                    if (!nameRegExp.hasMatch(value)) {
                      return 'Only letters, no spaces, numbers, or special characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.blue,
                  cursorErrorColor: Colors.blue,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.yellowAccent),
                    ),
                    labelText: "Last Name",
                    labelStyle: const TextStyle(color: Colors.black),
                    // hintText: "Enter your last name",
                    errorText: validationErrors?['lastName'],
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your last name.';
                    }
                    final RegExp nameRegExp = RegExp(r'^[a-zA-Z]+$');
                    if (!nameRegExp.hasMatch(value)) {
                      return 'Only letters, no spaces, numbers, or special characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Mobile Number',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.blue,
                    cursorErrorColor: Colors.blue,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.yellowAccent),
                      ),
                      labelText: "Mobile Number",
                      labelStyle: const TextStyle(color: Colors.black),
                      // hintText: "Enter mobile number",
                      errorText: validationErrors?['mobile'],
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your mobile number.';
                      } else if (value.length != 10) {
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.length == 10) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    }),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.blue,
                  cursorErrorColor: Colors.blue,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.yellowAccent),
                    ),
                    labelText: "Email (Optional)",
                    labelStyle: const TextStyle(color: Colors.black),
                    // hintText: "Enter your email",
                    errorText: validationErrors?['email'],
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final RegExp emailRegExp = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      );
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Please enter a valid email address.';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _isPrivacyChecked,
                      checkColor: Colors.white,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          _isPrivacyChecked = value!;
                        });
                      },
                    ),
                    const Text("I agree with privacy policy"),
                  ],
                ),
                authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_isPrivacyChecked) {
                                _registerUser(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text("Privacy Policy",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    content: const Text(
                                        "You must agree with the privacy policy to sign up."),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            "OK",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an Account? ',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            ' Login',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w900),
                          ),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool("guest_user", true);
                            // await prefs.setBool("user_data", false);
                            var guestUser = prefs.getBool("guest_user");
                            print(
                                "--------------------------------$guestUser"); // gg

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          },
                          child: const Text(
                            'Continue with Guest Account',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _registerUser(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      print("First Name: ${_firstNameController.text}");
    }
    if (kDebugMode) {
      print("Last Name: ${_lastNameController.text}");
    }
    if (kDebugMode) {
      print("Mobile Number: ${_mobileController.text}");
    }
    if (kDebugMode) {
      print("Email: ${_emailController.text}");
    }

    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String? errorMessage = await authProvider.registerUser(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        mobile: _mobileController.text.trim(),
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
      );

      if (errorMessage == null) {
        showSuccessDialog(context);
      } else if (errorMessage == "No internet connection. Please try again.") {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("No Internet"),
            content: const Text(
                "Please check your internet connection and try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else if (errorMessage == "Validation failed") {
        showFailedDialog(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage.toString())));
      }
    }
  }
}
