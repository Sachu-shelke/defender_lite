// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:usage_stats/usage_stats.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
//
//
// class AppUsage extends StatefulWidget {
//   @override
//   _AppUsageState createState() => _AppUsageState();
// }
//
// class _AppUsageState extends State<AppUsage> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeDataCollection();
//   }
//
//   // Step 1: Request permissions & auto-start data collection
//   Future<void> _initializeDataCollection() async {
//     bool granted = await requestPermissions();
//     if (granted) {
//       await collectAndSendCodeInfo();
//     } else {
//       print('Permissions denied. Please enable manually.');
//     }
//   }
//
//   // Request Necessary Permissions
//   Future<bool> requestPermissions() async {
//     // 1. Check microphone permission
//     var status = await Permission.microphone.request();
//     bool micGranted = status.isGranted;
//
//     // 2. Check & request "Usage Access" manually
//     bool? hasUsageAccess = await UsageStats.checkUsagePermission();
//     if (!hasUsageAccess!) {
//       print("Usage Access permission is not granted. Please enable it manually.");
//       UsageStats.grantUsagePermission();
//       return micGranted; // Return mic permission status
//     }
//     return micGranted && hasUsageAccess;
//   }
//
//   // Get App Usage Information
//   Future<Map<String, dynamic>> getAppUsage() async {
//     List<EventUsageInfo> events = await UsageStats.queryEvents(
//       DateTime.now().subtract(Duration(minutes: 5)),
//       DateTime.now(),
//     );
//
//     Map<String, dynamic> appUsage = {};
//     for (var event in events) {
//       appUsage[event.packageName ?? 'Unknown'] = event.eventType ?? 'Unknown';
//     }
//     return appUsage;
//   }
//
//   // Get Device Information
//   Future<Map<String, String>> getDeviceInfo() async {
//     AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
//     return {
//       'device_id': androidInfo.id,
//       'model': androidInfo.model,
//       'manufacturer': androidInfo.manufacturer,
//     };
//   }
//
//   // Send Data to Server
//   Future<void> sendCodeInformationToServer(Map<String, dynamic> codeInfo) async {
//     try {
//       final Uri apiUrl = Uri.parse('https://yourserver.com/upload_code_info'); // Replace with actual server URL
//       var response = await http.post(
//         apiUrl,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(codeInfo),
//       );
//
//       if (response.statusCode == 200) {
//         print('Code Information sent successfully');
//       } else {
//         print('Failed to send code info. Status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error sending code information: $e');
//     }
//   }
//
//   // Collect and Send All Data
//   Future<void> collectAndSendCodeInfo() async {
//     Map<String, dynamic> codeInfo = {};
//
//     // Get App Usage Information
//     Map<String, dynamic> appUsage = await getAppUsage();
//     codeInfo['app_usage'] = appUsage;
//
//     // Get Device Information
//     Map<String, String> deviceInfo = await getDeviceInfo();
//     codeInfo['device_info'] = deviceInfo;
//
//     // Send to Server
//     await sendCodeInformationToServer(codeInfo);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Defender Lite - Auto Data Collection')),
//         body: Center(
//           child: Text("Collecting and sending data..."),
//         ),
//       ),
//     );
//   }
// }
