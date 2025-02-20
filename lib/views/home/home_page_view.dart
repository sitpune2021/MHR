import 'package:flutter/material.dart';
import 'package:machine_hour_rate/core/theme/colors.dart';
import 'package:machine_hour_rate/views/calculation.dart';
import 'package:machine_hour_rate/views/home/home_screen.dart';
import 'package:machine_hour_rate/views/pages/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool isGuestUser = false;

  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const CalculationSheet(),
      SettingsPage(isGuestUser: isGuestUser),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        automaticallyImplyLeading: false,
        title: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 28,
          child: Image.asset(
            'assets/logo.png',
            width: 40,
          ),
        ),
        // centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: true, // This will show the label when selected
          backgroundColor: kBackgroundColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_rounded),
              label: 'Calculation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
