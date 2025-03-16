// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:machine_hour_rate/views/home/home_page_view.dart';
import 'package:machine_hour_rate/views/login/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider with ChangeNotifier {
  bool isSplashVisible = true;

  void hideSplash() {
    isSplashVisible = false;
    notifyListeners();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool hasInternet = true;
  bool is_login = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();

    // Future.delayed(const Duration(seconds: 3), () {
    //   Provider.of<SplashProvider>(context, listen: false).hideSplash();
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const RegisterScreen()),
    //   );
    // });
    isLoggedIn();
  }

  // void isLoggedIn() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //   bool isLoggedGuestUser = prefs.getBool('isLoggedGuestUser') ?? false;

  //   if (isLoggedIn == true) {
  //     Timer(const Duration(seconds: 3), () {
  //       Provider.of<SplashProvider>(context, listen: false).hideSplash();
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const RegisterScreen()),
  //       );
  //     });
  //   } else if (isLoggedGuestUser == true) {
  //     Timer(const Duration(seconds: 3), () {
  //       Provider.of<SplashProvider>(context, listen: false).hideSplash();
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const HomePage()),
  //       );
  //     });
  //   } else {
  //     Timer(const Duration(seconds: 3), () {
  //       Provider.of<SplashProvider>(context, listen: false).hideSplash();
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const HomePage()),
  //       );
  //     });
  //   }
  // }

  void isLoggedIn() async {
    // Delay for showing the splash screen
    Timer(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      bool isLoggedGuestUser = prefs.getBool('isLoggedGuestUser') ?? false;

      // Hide the splash screen
      Provider.of<SplashProvider>(context, listen: false).hideSplash();

      if (isLoggedIn) {
        // If logged in, navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if (isLoggedGuestUser) {
        // If Guest user, navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Not logged in or a guest user, navigate to RegisterScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: splashProvider.isSplashVisible
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _animation,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'MACHINE HOUR RATE',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      Color(0xFF207AC5),
                                      Color(0xFF9DC558),
                                      Color(0xFF44B264),
                                    ],
                                  ).createShader(const Rect.fromLTWH(
                                      0.0, 0.0, 200.0, 70.0)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Efficiently calculate',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                // color: Colors.lightBlue,
                              ),
                            ),
                            const Text(
                              'Machine Hour Rates',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                // color: Colors.lightBlue,
                              ),
                            ),
                            const Text(
                              'with Precision',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                // color: Colors.lightBlue,
                              ),
                            ),
                          ]),
                    ],
                  ),
                )
              : Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.white,
                    size: 10,
                  ),
                ),
        );
      },
    );
  }
}
