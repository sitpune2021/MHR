// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:machine_hour_rate/core/theme/colors.dart';
// import 'package:machine_hour_rate/views/home/home_screen.dart';
// import 'package:machine_hour_rate/views/login/forgot_screen.dart';
// import 'package:machine_hour_rate/views/login/register_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _rememberMe = false;

//   void _login() {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//       Future.delayed(const Duration(seconds: 2), () {
//         setState(() {
//           _isLoading = false;
//         });
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       });
//     }
//   }

//   void _navigateToForgotPassword() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ForgotPassScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/logo.png',
//                 height: 100,
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _mobileController,
//                 keyboardType: TextInputType.phone,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(10),
//                 ],
//                 decoration: const InputDecoration(
//                   labelText: "Mobile Number",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your mobile number";
//                   } else if (value.length != 10) {
//                     return "Mobile number must be 10 digits";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 inputFormatters: [
//                   LengthLimitingTextInputFormatter(20),
//                 ],
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your password";
//                   } else if (value.length < 6) {
//                     return "Password must be at least 6 characters";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: _rememberMe,
//                         onChanged: (value) {
//                           setState(() {
//                             _rememberMe = value!;
//                           });
//                         },
//                       ),
//                       const Text("Remember Me"),
//                     ],
//                   ),
//                   TextButton(
//                     onPressed: _navigateToForgotPassword,
//                     child: const Text("Forgot Password?"),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0, vertical: 12.0),
//                         backgroundColor: kButtonColor,
//                         foregroundColor: Colors.black87,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       onPressed: _login,
//                       child: const Text("Login"),
//                     ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const RegisterScreen()),
//                   );
//                 },
//                 child: const Text(
//                   'Create new account! Register Now',
//                   style: TextStyle(color: Colors.green),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
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
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String result = await authProvider.loginUser(
        _mobileController.text.trim(),
        _passwordController.text.trim(),
      );
      if (result == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userData = prefs.getString("userData");
        print("Stored User Data: $userData");

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

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPassScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 100),
              const SizedBox(height: 20),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  labelText: "Mobile Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your mobile number";
                  } else if (value.length != 10) {
                    return "Mobile number must be 10 digits";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      const Text("Remember Me"),
                    ],
                  ),
                  TextButton(
                    onPressed: _navigateToForgotPassword,
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        backgroundColor: kButtonColor,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: _login,
                      child: const Text("Login"),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  'Create new account! Register Now',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
