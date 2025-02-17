import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:permission_handler/permission_handler.dart';

class OverlayPermissionScreen extends StatefulWidget {
  @override
  _OverlayPermissionScreenState createState() =>
      _OverlayPermissionScreenState();
}

class _OverlayPermissionScreenState extends State<OverlayPermissionScreen> {
  Future<void> checkAndRequestOverlayPermission() async {
    if (await Permission.systemAlertWindow.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Overlay permission already granted!")),
      );
    } else {
      openOverlaySettings();
    }
  }

  void openOverlaySettings() {
    final intent = AndroidIntent(
      action: "android.settings.action.MANAGE_OVERLAY_PERMISSION",
      data: "package:${'com.info.defenders'}",
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Allow Display Over Apps")),
      body: Center(
        child: ElevatedButton(
          onPressed: checkAndRequestOverlayPermission,
          child: Text("Enable Display Over Other Apps"),
        ),
      ),
    );
  }
}
