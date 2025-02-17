import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class ScreenMonitorApp extends StatefulWidget {
  @override
  _ScreenMonitorAppState createState() => _ScreenMonitorAppState();
}

class _ScreenMonitorAppState extends State<ScreenMonitorApp> {
  String _appState = "App is in the foreground"; // Default state
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      checkAppState();
    });
  }

  // Monitor app state (foreground or background)
  Future<void> checkAppState() async {
    // Assume your app is in the foreground
    String appState = "foreground";

    sendScreenStateToServer(appState);
    setState(() {
      _appState = appState == "foreground"
          ? "App is in the foreground"
          : "App is in the background";
    });
  }

  // Send screen monitoring data to the server
  Future<void> sendScreenStateToServer(String appState) async {
    final Uri apiUrl = Uri.parse('https://yourserver.com/screen_monitoring');

    try {
      Map<String, dynamic> data = {
        "device_id": "DEVICE_UNIQUE_ID",  // Use actual device ID
        "app_state": appState,  // "foreground" or "background"
        "timestamp": DateTime.now().toIso8601String(),
      };

      var response = await http.post(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Screen state sent successfully.");
      } else {
        print("Failed to send screen state: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending screen state: $e");
    }
  }

  @override
  void dispose() {
    _timer.cancel();  // Cancel the timer when the app is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Screen Monitoring App'),
        ),
        body: Center(
          child: Text(
            _appState,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
