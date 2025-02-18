// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:machine_hour_rate/views/login/register_screen.dart';
import 'package:provider/provider.dart';

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

    Future.delayed(const Duration(seconds: 6), () {
      Provider.of<SplashProvider>(context, listen: false).hideSplash();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
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
                      Text(
                        'MACHINE HOUR RATE',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              // begin: Alignment.bottomCenter,
                              // end: Alignment.topCenter,
                              colors: [
                                Color(0xFF207AC5),
                                Color(0xFF9DC558),
                                Color(0xFF44B264),
                                // Blue
                              ],
                            ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Efficiently calculate',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.normal,
                          // color: Colors.lightBlue,
                        ),
                      ),
                      const Text(
                        'Machine Hour Rates',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          // color: Colors.lightBlue,
                        ),
                      ),
                      const Text(
                        'with Precision',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.normal,
                          // color: Colors.lightBlue,
                        ),
                      ),
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
