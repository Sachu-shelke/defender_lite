import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class CallSmsScreen extends StatefulWidget {
  @override
  _CallSmsScreenState createState() => _CallSmsScreenState();
}

class _CallSmsScreenState extends State<CallSmsScreen> with SingleTickerProviderStateMixin {
  static const platform = MethodChannel('call_sms_log_channel');
  List<Map<String, String>> callLogs = [];
  List<Map<String, String>> smsLogs = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getCallLogs();
    _getSmsLogs();
  }

  Future<void> _getCallLogs() async {
    if (await Permission.phone.request().isGranted) {
      try {
        final List<dynamic> logs = await platform.invokeMethod('getCallLogs');
        setState(() {
          callLogs = logs.map((e) => Map<String, String>.from(e)).toList();
        });
      } on PlatformException catch (e) {
        print("Error fetching call logs: ${e.message}");
      }
    } else {
      print("Call Log permission not granted.");
    }
  }

  Future<void> _getSmsLogs() async {
    if (await Permission.sms.request().isGranted) {
      try {
        final List<dynamic> logs = await platform.invokeMethod('getSmsLogs');
        setState(() {
          smsLogs = logs.map((e) => Map<String, String>.from(e)).toList();
        });
      } on PlatformException catch (e) {
        print("Error fetching SMS logs: ${e.message}");
      }
    } else {
      print("SMS permission not granted.");
    }
  }

  String _formatDuration(String? duration) {
    if (duration == null) return "Duration: 0 sec";
    int seconds = int.tryParse(duration) ?? 0;
    if (seconds < 60) {
      return "Duration: $seconds sec";
    } else {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      return "Duration: $minutes min ${remainingSeconds > 0 ? '$remainingSeconds sec' : ''}";
    }
  }

  Widget _buildCallLogs() {
    return ListView.builder(
      itemCount: callLogs.length,
      itemBuilder: (context, index) {
        final call = callLogs[index];
        return ListTile(
          title: Text(call['number'] ?? 'Unknown'),
          subtitle: Text(_formatDuration(call['duration'])),
          trailing: Text(call['type'] == "1" ? "Incoming" : "Outgoing"),
        );
      },
    );
  }

  Widget _buildSmsLogs() {
    return ListView.builder(
      itemCount: smsLogs.length,
      itemBuilder: (context, index) {
        final sms = smsLogs[index];

        return ExpansionTile(
          title: Text(sms['address'] ?? 'Unknown'),
          subtitle: Text("Tap to view message"),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                sms['body'] ?? "No message content",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Call & SMS Logs"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Calls"),
            Tab(text: "SMS"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCallLogs(),
          _buildSmsLogs(),
        ],
      ),
    );
  }
}
