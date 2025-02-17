import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;


class CallLogsApp extends StatefulWidget {
  @override
  _CallLogsAppState createState() => _CallLogsAppState();
}

class _CallLogsAppState extends State<CallLogsApp> {
  List<Map<String, dynamic>> callList = [];

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      // You can call another function here if needed
    }
  }

  Future<void> sendCallDataToServer(List<Map<String, dynamic>> callData) async {
    String apiUrl = "https://yourserver.com/api/calls"; // Replace with actual API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"call_logs": callData}),
      );

      if (response.statusCode == 200) {
        print("Call data sent successfully");
      } else {
        print("Failed to send call data: ${response.body}");
      }
    } catch (e) {
      print("Error sending call data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Defender Lite')),
        body: Center(
          child: Text('Call logging removed. No data to display.'),
        ),
      ),
    );
  }
}
