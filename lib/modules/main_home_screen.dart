// import 'package:defender_lite/modules/qr_code/genrate_code.dart';
// import 'package:defender_lite/modules/qr_code/scanner.dart';
// import 'package:defender_lite/modules/splash_screen/Main_Home_screen.dart';
// import 'package:flutter/material.dart';
//
// import 'accessiblity/accessilbilty_permission.dart';
// import 'basic_permission/mobile_permission.dart';
//
// class MainHomeScreen extends StatefulWidget {
//   const MainHomeScreen({super.key});
//
//   @override
//   State<MainHomeScreen> createState() => _MainHomeScreenState();
// }
//
// class _MainHomeScreenState extends State<MainHomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('Home Screen'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Text('Welcome to the Home Screen!'),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>GenrateCode()));
//               },
//               child: Text('genrate qr code'),
//             ),
//             ElevatedButton(onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>PermissionsScreen()));
//             }, child: Text("Scan Code"),
//       ),
//       ElevatedButton(
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreen()));
//         }, child: Text('Splash screen'), )
//           ],
//         ),
//       ),
//     );
//   }
// }
