import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isOtpSent = false;
  bool _isResendEnabled = false;

  Timer? _timer;
  int _remainingTime = 30;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Future<void> _loginUserOtp() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //     String? result = await authProvider.loginUserOtp(
  //         mobile: _mobileController.text.trim());

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:
  //             Text(result ?? "Something went wrong"), // ✅ Show correct message
  //         backgroundColor:
  //             (result != null && result.toLowerCase().contains("success"))
  //                 ? Colors.green
  //                 : Colors.red,
  //       ),
  //     );

  //     if (result != null &&
  //         (result.toLowerCase().contains("success") ||
  //             result.toLowerCase().contains("otp sent"))) {
  //       setState(() {
  //         _isOtpSent = true; // ✅ Show OTP input field
  //         _isResendEnabled = false;
  //         _remainingTime = 30;
  //       });
  //       _startTimer();
  //     }
  //   }
  // }

  Future<void> _loginUserOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      setState(() {
        _isOtpSent = false; // Disable Send OTP button while sending request
      });

      String? result = await authProvider.loginUserOtp(
          mobile: _mobileController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? "Something went wrong"),
          backgroundColor: (result!.toLowerCase().contains("success"))
              ? Colors.green
              : Colors.red,
        ),
      );

      if ((result.toLowerCase().contains("success") ||
          result.toLowerCase().contains("otp sent"))) {
        setState(() {
          _isOtpSent = true;
          _isResendEnabled = false;
          _remainingTime = 30;
        });
        _startTimer();
      } else {
        setState(() {
          _isOtpSent = false;
        });
      }
    }
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String? errorMessage = await authProvider.loginUser(
        mobile: _mobileController.text.trim(),
        otp: _otpController.text.trim(),
      );

      if (errorMessage == "No internet connection. Please try again.") {
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

  void _startOtpTimer() {
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allows only numbers
                            LengthLimitingTextInputFormatter(
                                10), // Limits input to 10 digits
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.yellowAccent),
                            ),
                            labelText: "Mobile Number",
                            labelStyle: const TextStyle(color: Colors.black),
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
                            } else if (value.length != 10) {
                              return 'Mobile number must be 10 digits';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.length == 10) {
                              FocusManager.instance.primaryFocus
                                  ?.unfocus(); // Closes the keyboard
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Send OTP Button
                // !_isOtpSent
                //     ? SizedBox(
                //         width: MediaQuery.sizeOf(context).width * 0.28,
                //         height: 40,
                //         child: ElevatedButton(
                //           onPressed: _loginUserOtp,
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.blue,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(25),
                //             ),
                //           ),
                //           child: const Text(
                //             "Send OTP",
                //             style: TextStyle(fontSize: 18, color: Colors.white),
                //           ),
                //         ),
                //       )
                //     : Column(
                //         children: [
                //           Text("OTP sent! Resend in $_remainingTime sec"),
                //           const SizedBox(height: 10),
                //           // OTP Input Field with pin_code_fields
                //           PinCodeTextField(
                //             appContext: context,
                //             length: 6,
                //             controller: _otpController,
                //             keyboardType: TextInputType.number,
                //             pinTheme: PinTheme(
                //               shape: PinCodeFieldShape.box,
                //               borderRadius:
                //                   const BorderRadius.all(Radius.circular(18)),
                //               fieldHeight: 50,
                //               fieldWidth: 40,
                //               activeColor: Colors.grey,
                //               inactiveColor: Colors.grey,
                //               selectedColor: Colors.grey,
                //             ),
                //             onChanged: (value) {
                //               print(value);
                //             },
                //           ),
                //           const SizedBox(height: 5),
                //           _isResendEnabled
                //               ? ElevatedButton(
                //                   onPressed: _loginUserOtp,
                //                   style: ElevatedButton.styleFrom(
                //                     backgroundColor: Colors.blue,
                //                     shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(25),
                //                     ),
                //                   ),
                //                   child: const Text(
                //                     "Resend OTP",
                //                     style: TextStyle(
                //                         fontSize: 18, color: Colors.white),
                //                   ),
                //                 )
                //               : Container(), // Hide Resend button until timer ends

                //   ],
                // ),
                // Send OTP Button
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.28,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _isOtpSent
                        ? null
                        : _loginUserOtp, // ✅ Disable button after click
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      _isOtpSent
                          ? "OTP Sent"
                          : "Send OTP", // ✅ Change button text dynamically
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

// OTP Input Field
                _isOtpSent
                    ? Column(
                        children: [
                          Text("OTP sent! Resend in $_remainingTime sec"),
                          const SizedBox(height: 10),
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeColor: Colors.grey,
                              inactiveColor: Colors.grey,
                              selectedColor: Colors.grey,
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 5),
                          _isResendEnabled
                              ? ElevatedButton(
                                  onPressed: _loginUserOtp,
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
                      )
                    : Container(), // Hide OTP field if OTP not sent

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
                              onPressed: !authProvider.isLoading
                                  ? () => _loginUser()
                                  : null,
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
