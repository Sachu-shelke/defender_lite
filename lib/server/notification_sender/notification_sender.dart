import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';


class NotificationSenderScreen extends StatefulWidget {
  @override
  _NotificationSenderScreenState createState() =>
      _NotificationSenderScreenState();
}

class _NotificationSenderScreenState extends State<NotificationSenderScreen> {
  String _statusMessage = "Starting notification service...";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoNotification();
  }

  // Get Device ID
  Future<String> getDeviceId() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.id;
  }

  // Send Notification
  Future<void> sendNotification() async {
    String deviceId = await getDeviceId();
    var data = {
      "device_id": deviceId,
      "notification": "Automatic notification from Defender Lite"
    };

    try {
      final Uri apiUrl = Uri.parse(
          'https://yourserver.com/notification'); // Update with actual server URL
      var response = await http.post(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        setState(() =>
        _statusMessage = "Notification sent at ${DateTime.now()}");
      } else {
        setState(() => _statusMessage = "Failed to send notification!");
      }
    } catch (e) {
      setState(() => _statusMessage = "Error: $e");
    }
  }

  // Automatically Send Notifications at Intervals
  void _startAutoNotification() {
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      sendNotification();
    });
    sendNotification(); // Send immediately at startup
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop timer when screen is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Auto Notification Sender")),
      body: Center(
        child: Text(
            _statusMessage, style: TextStyle(fontSize: 16, color: Colors.blue)),
      ),
    );
  }
}
