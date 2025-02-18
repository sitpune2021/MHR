import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:machine_hour_rate/views/home/home_screen.dart';
import 'package:machine_hour_rate/views/login/forgot_screen.dart';
import 'package:machine_hour_rate/views/login/register_screen.dart';
import 'package:machine_hour_rate/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String _selectedCountryCode = "+91"; // Default to India
  bool _rememberMe = false;
  bool _isOtpSent = false;
  bool _isResendEnabled = false;
  bool _isLoading = false;

  Timer? _timer;
  int _remainingTime = 30;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /* void _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String result = await authProvider.loginUser(
        _mobileController.text.trim(),
      );
      if (result == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userData = prefs.getString("userData");
        if (kDebugMode) {
          print("Stored User Data: $userData");
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Successful"),
            content: const Text("Welcome back!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.red),
        );
      }
      // if (result == "success") {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   String? userData = prefs.getString("userData");
      //   print("Stored User Data: $userData");

      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const HomeScreen()),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(result), backgroundColor: Colors.red),
      //   );
      // }
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 60,
            bottom: 40,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Login Account', style: TextStyle(fontSize: 34)),
                  ],
                ),
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Welcome back', style: TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(height: 20),
                const Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/logo.png"),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Mobile Number', style: TextStyle(fontSize: 24)),
                  ],
                ),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "+91",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.yellowAccent),
                            ),
                            labelText: "Mobile Number",
                            hintText: "Enter mobile number",
                            // errorText: validationErrors?['mobile'],
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            // Add  validation if needed
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Send OTP Button
                !_isOtpSent
                    ? SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.25,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            "Send OTP",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Text("OTP sent! Resend in $_remainingTime sec"),
                          const SizedBox(height: 10),
                          // OTP Input Field with pin_code_fields
                          PinCodeTextField(
                            appContext: context,
                            length: 5,
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),

                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeColor: Colors.grey,
                              inactiveColor: Colors.grey,
                              // inactiveFillColor: Colors.yellowAccent,
                              selectedColor: Colors.grey,
                            ),
                            onChanged: (value) {
                              print(value); // Optional: For handling OTP input
                            },
                          ),
                          const SizedBox(height: 5),
                          _isResendEnabled
                              ? ElevatedButton(
                                  onPressed: _sendOtp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text(
                                    "Resend OTP",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                )
                              : Container(), // Hide Resend button until timer ends
                        ],
                      ),
                const SizedBox(height: 10),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0, top: 100),
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              // onPressed: !authProvider.isLoading
                              //     ? () => _login()
                              //     : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'don\'t have an account? Sign Up',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _sendOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      // Simulate OTP send operation (e.g., API call)
      setState(() {
        _isOtpSent = true;
        _isResendEnabled = false;
        _remainingTime = 30; // Reset the timer
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        _timer?.cancel();
      }
    });
  }
}
