// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:machine_hour_rate/models/userModel.dart';
import 'package:machine_hour_rate/views/login/verification_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:machine_hour_rate/views/login/register_screen.dart';
import 'package:machine_hour_rate/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isOtpSent = false;
  bool _isResendEnabled = false;
  int _remainingTime = 30;
  Timer? _timer;

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isResendEnabled = false;
      _remainingTime = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
      });

      if (_remainingTime <= 0) {
        _timer?.cancel();
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  Future<void> _loginUserOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final mobileNumber = _mobileController.text.trim();
      if (mobileNumber.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid 10-digit mobile number.'),
            // duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String? result = await authProvider.loginUserOtp(
          mobile: _mobileController.text.trim());
      if (result != null) {
        if (result.toLowerCase().contains("invalid mobile number") ||
            result.toLowerCase().contains("not registered mobile number")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Number not registered, please register before you login.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? "Something went wrong"),
          backgroundColor: (result!.toLowerCase().contains("success"))
              ? Colors.red
              : Colors.green,
        ),
      );
      if (result.toLowerCase().contains("success") ||
          result.toLowerCase().contains("otp sent")) {
        _startTimer();
      } else {
        setState(() {
          _isOtpSent = true;
          _startTimer();
        });
      }
    }
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (_isOtpSent) {
        if (_otpController.text.length != 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP must be 6 digits long.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
      }
      String? errorMessage = await authProvider.loginUser(
        mobile: _mobileController.text.trim(),
        otp: _otpController.text.trim(),
      );
      if (errorMessage == null || errorMessage.isEmpty) {
        showLoginDialog(context);
      } else if (_isOtpSent &&
          (_otpController.text.isEmpty || _otpController.text.length != 6)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter the OTP to proceed.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Mobile Number', style: TextStyle(fontSize: 24)),
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
                      borderSide: const BorderSide(color: Colors.yellowAccent),
                    ),
                    labelText: "Mobile Number",
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: "Enter mobile number",
                    // errorText: validationErrors?['mobile'],
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
                      return 'Enter your Registered mobile number';
                    } else if (value.length != 10) {
                      return 'Mobile number must be 10 digits';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length == 10) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.28,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _isOtpSent ? null : _loginUserOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      _isOtpSent ? "OTP Sent" : "Send OTP",
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_isOtpSent) ...[
                  Text("OTP sent! Resend in $_remainingTime sec"),
                  const SizedBox(height: 10),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeColor: Colors.grey,
                      inactiveColor: Colors.grey,
                      selectedColor: Colors.grey,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Submit otp';
                      } else if (value.length != 6) {
                        return 'otp must be 6 digit';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 5),
                  _isResendEnabled
                      ? ElevatedButton(
                          onPressed: _isResendEnabled ? _loginUserOtp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            "Resend OTP",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                      : Container(),
                ],
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0, top: 60),
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                authProvider.isLoading ? null : _loginUser,
                            // authProvider.isLoading
                            //     ? () => _loginUser()
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
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'don\'t have an account? ',
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w900),
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
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
