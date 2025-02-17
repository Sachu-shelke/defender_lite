// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'modules/splash_screen/splash_screen.dart';
// import 'modules/home/home_screen.dart';
// import 'modules/basic_permission/parent_consent_screen.dart';
// import 'modules/binding/binding_screen.dart';
// import 'modules/profile/child_profile.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   Widget? initialScreen;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadInitialScreen();
//   }
//
//   Future<void> _loadInitialScreen() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     bool hasOpenedBefore = prefs.getBool('hasOpenedBefore') ?? false;
//     bool hasProfileCompleted = prefs.getBool('hasProfileCompleted') ?? false;
//     bool isFirstTimeConsent = prefs.getBool('isFirstTimeConsent') ?? true;
//     bool hasSeenSplash = prefs.getBool('hasSeenSplash') ?? false;
//
//     setState(() {
//       if (!hasSeenSplash) {
//         initialScreen = SplashScreen();
//       } else if (isFirstTimeConsent) {
//         initialScreen = ParentalConsentScreen();
//       } else if (!hasOpenedBefore) {
//         initialScreen = BindingScreen();
//       } else if (!hasProfileCompleted) {
//         initialScreen = ChildProfileScreen();
//       } else {
//         initialScreen = HomeScreen();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: initialScreen ?? Scaffold(
//         body: Center(child: CircularProgressIndicator()), // Loading indicator
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'modules/splash_screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
