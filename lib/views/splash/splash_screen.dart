// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:machine_hour_rate/views/home/home_screen.dart';
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
        MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                      const Text(
                        'MACHINE HOUR RATE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        ' Efficiently calculate Machine Hour Rates with Precision ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
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
