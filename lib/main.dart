import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding.dart';
import 'homescreen.dart';
import 'mapscreen.dart';
import 'learnscreen.dart';
import 'rankingscreen.dart';
import 'settingsscreen.dart';
import 'cities.dart';
//hi
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onboarding Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/home': (context) => AirQualityScreen(),
        '/mapscreen': (context) =>  MapScreen(),
      },
    );
  }

}

class AirQualityScreen extends StatefulWidget {
  const AirQualityScreen({Key? key}) : super(key: key);

  @override
  _AirQualityScreenState createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MapScreen(isFromMenu: true),
    const LearnScreen(),
    const RankingScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor:  const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Ranking'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}