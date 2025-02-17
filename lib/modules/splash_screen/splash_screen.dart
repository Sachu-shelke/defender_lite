import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_screen.dart';
import '../basic_permission/parent_consent_screen.dart';
import '../binding/binding_screen.dart';
import '../profile/child_profile.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    bool hasOpenedBefore = prefs.getBool('hasOpenedBefore') ?? false;
    bool hasProfileCompleted = prefs.getBool('hasProfileCompleted') ?? false;
    bool isFirstTimeConsent = prefs.getBool('isFirstTimeConsent') ?? true;

    Widget nextScreen;

    if (isFirstTime) {
      // First time logic
      await prefs.setBool('isFirstTime', false);
      if (isFirstTimeConsent) {
        nextScreen = ParentalConsentScreen();
      } else if (!hasOpenedBefore) {
        nextScreen = BindingScreen();
      } else if (!hasProfileCompleted) {
        nextScreen = ChildProfileScreen();
      } else {
        nextScreen = HomeScreen();
      }
    } else {
      // All future opens -> Splash then HomeScreen
      nextScreen = HomeScreen();
    }

    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircleAvatar(
          radius: 80,
          backgroundImage: AssetImage('assets/images/logo.jpg'),
        )
      ),
    );
  }
}
