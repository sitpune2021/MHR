import 'package:flutter/material.dart';
import 'package:machine_hour_rate/views/home/home_page_view.dart';
import 'package:machine_hour_rate/views/login/login_screen.dart';

void showSuccessDialog(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 10,
        ),
        content: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Account Created",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text("Welcome", style: TextStyle(fontSize: 15)),
              const SizedBox(height: 5),
              Image.asset('assets/Animation_tick.gif', height: 100, width: 100),
              const SizedBox(height: 5),
              const Text(
                "Your account has been created",
                style: TextStyle(fontSize: 15),
              ),
              const Text(
                "Successfully!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    },
  );
}

void showFailedDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 10,
        ),
        content: SizedBox(
          height: 250,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Account Creation Failed",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Sorry",
                style: TextStyle(fontSize: 26),
              ),
              Image.asset('assets/Animation_failed.gif',
                  height: 100, width: 100),
              const SizedBox(height: 5),
              const Text(
                "Your account could not be created",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Please try again later!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    },
  );
}

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 10,
        ),
        content: SizedBox(
          height: 250,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Login Successful",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text("Welcome", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Image.asset('assets/Animation_tick.gif', height: 100, width: 100),
              const SizedBox(height: 5),
              const Text(
                "You have successfully logged in",
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "Enjoy the app!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    },
  );
}

// void showTopSnackBar(
//   String message, {
//   bool isSuccess = true,
//   Color? color,
//   Duration? duration,
// }) {
//   final backgroundColor =
//       color ?? (isSuccess ? Colors.green[600] : Colors.red[600]);

//   ScaffoldMessenger.of( WidgetsBinding.instance.conte).showSnackBar(
//     SnackBar(
//       duration: duration ?? const Duration(milliseconds: 500),
//       backgroundColor: Colors.transparent,
//       content: Align(
//         alignment: Alignment.topCenter,
//         child: Container(
//           height: 100,
//           margin: const EdgeInsets.all(20),
//           padding: const EdgeInsets.all(20),
//           width: double.maxFinite,
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: const BorderRadius.all(
//               Radius.circular(15),
//             ),
//           ),
//           child: Text(
//             message,
//             style: const TextStyle(
//               fontSize: 20,
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// void showTopSnackBar(
//   context,
//   String message, {
//   bool isSuccess = true,
//   Color? color,
//   Duration? duration,
// }) {
//   final backgroundColor =
//       color ?? (isSuccess ? Colors.green[600] : Colors.red[600]);

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       duration: duration ?? const Duration(milliseconds: 500),
//       backgroundColor: Colors.transparent,
//       content: Align(
//         alignment: Alignment.topCenter,
//         child: Container(
//           height: 100,
//           margin: const EdgeInsets.all(20),
//           padding: const EdgeInsets.all(20),
//           width: double.maxFinite,
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: const BorderRadius.all(
//               Radius.circular(15),
//             ),
//           ),
//           child: Text(
//             message,
//             style: const TextStyle(
//               fontSize: 20,
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

  // void showTopSnackBar(BuildContext context, String message) {
  //   final overlay = Overlay.of(context);
  //   final overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: 10,
  //       left: 0,
  //       right: 0,
  //       child: Material(
  //         child: Container(
  //           height: 50,
  //           color: Colors.blue,
  //           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //           child: Text(
  //             message,
  //             style: const TextStyle(color: Colors.white),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   overlay.insert(overlayEntry);

  //   Future.delayed(const Duration(seconds: 10), () {
  //     overlayEntry.remove();
  //   });
  // }

    // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       Container(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 15, vertical: 20),
                //         decoration: BoxDecoration(
                //           border: Border.all(color: Colors.grey),
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         child: const Text(
                //           "+91",
                //           style: TextStyle(fontSize: 16),
                //         ),
                //       ),
                //       const SizedBox(width: 10),
                //       Expanded(
                //         child: TextFormField(
                //           controller: _mobileController,
                //           keyboardType: TextInputType.phone,
                //           cursorColor: Colors.black,
                //           inputFormatters: [
                //             FilteringTextInputFormatter
                //                 .digitsOnly, // Allows only numbers
                //             LengthLimitingTextInputFormatter(
                //                 10), // Limits input to 10 digits
                //           ],
                //           decoration: InputDecoration(
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(10.0),
                //               borderSide:
                //                   const BorderSide(color: Colors.yellowAccent),
                //             ),
                //             labelText: "Mobile Number",
                //             labelStyle: const TextStyle(color: Colors.black),
                //             hintText: "Enter mobile number",

                //             // errorText: validationErrors?['mobile'],
                //             focusedBorder: const OutlineInputBorder(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(10.0)),
                //               borderSide:
                //                   BorderSide(color: Colors.blue, width: 2.0),
                //             ),
                //             errorBorder: const OutlineInputBorder(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(10.0)),
                //               borderSide:
                //                   BorderSide(color: Colors.grey, width: 2.0),
                //             ),
                //           ),
                //           validator: (value) {
                //             if (value == null || value.isEmpty) {
                //               return 'Enter your Registered mobile number';
                //             } else if (value.length != 10) {
                //               return 'Mobile number must be 10 digits';
                //             }
                //             return null;
                //           },
                //           onChanged: (value) {
                //             if (value.length == 10) {
                //               FocusManager.instance.primaryFocus?.unfocus();
                //             }
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),