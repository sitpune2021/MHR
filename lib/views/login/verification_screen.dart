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
