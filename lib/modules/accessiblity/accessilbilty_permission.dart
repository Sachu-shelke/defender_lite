import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AccessibilityPermission extends StatefulWidget {
  const AccessibilityPermission({super.key});

  @override
  State<AccessibilityPermission> createState() => _AccessibilityPermissionState();
}

class _AccessibilityPermissionState extends State<AccessibilityPermission> {
  String _permissionStatus = "Permission Status: Unknown";

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    // Check if the permission is granted
    PermissionStatus status = await Permission.camera.status;

    // If the permission is granted, update the UI
    setState(() {
      _permissionStatus = status.isGranted
          ? "Camera Permission Granted"
          : "Camera Permission Denied";
    });
  }

  Future<void> _requestPermission() async {
    // Request the camera permission
    PermissionStatus status = await Permission.camera.request();

    setState(() {
      _permissionStatus = status.isGranted
          ? "Camera Permission Granted"
          : "Camera Permission Denied";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accessibility Permission")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _permissionStatus,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestPermission,
              child: const Text("Request Camera Permission"),
            ),
          ],
        ),
      ),
    );
  }
}
