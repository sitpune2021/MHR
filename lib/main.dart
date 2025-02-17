import 'package:flutter/material.dart';
import 'package:machine_hour_rate/providers/auth_provider.dart';
import 'package:machine_hour_rate/views/home/home_screen.dart';
import 'package:machine_hour_rate/views/splash/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<SplashProvider>(
        builder: (context, splashProvider, child) {
          return splashProvider.isSplashVisible
              ? const SplashScreen()
              // : const HomeScreen();
              : const SplashScreen();
        },
      ),
    );
  }
}
