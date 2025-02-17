import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

import '../accessiblity/ac.dart';

class PermissionsScreen extends StatefulWidget {
  @override
  _PermissionsScreenState createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  // Store the state of each switch in a map
  Map<String, bool> permissionStatus = {
    'Accessibility Permissions': false,
    'Allow Display Over Other Apps': false,
    'Camera Permission': false,
    'Microphone Permission': false,
    'User Usage Permission': false,
    'Phone Permission': false,
    'Access Notification': false,
    'Location Permission': false,
  };

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  // Load the saved permission states from SharedPreferences
  Future<void> _loadPermissions() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      permissionStatus['Accessibility Permissions'] =
          prefs.getBool('Accessibility Permissions') ?? false;
      permissionStatus['Allow Display Over Other Apps'] =
          prefs.getBool('Allow Display Over Other Apps') ?? false;
      permissionStatus['Camera Permission'] =
          prefs.getBool('Camera Permission') ?? false;
      permissionStatus['Microphone Permission'] =
          prefs.getBool('Microphone Permission') ?? false;
      permissionStatus['User Usage Permission'] =
          prefs.getBool('User Usage Permission') ?? false;
      permissionStatus['Phone Permission'] =
          prefs.getBool('Phone Permission') ?? false;
      permissionStatus['Access Notification'] =
          prefs.getBool('Access Notification') ?? false;
      permissionStatus['Location Permission'] =
          prefs.getBool('Location Permission') ?? false;
    });
  }

  // Save the permission state to SharedPreferences
  Future<void> _savePermissionState(String permission, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(permission, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Permissions')),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 150,
                  child: Image.asset(
                    'assets/sticker/permission.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                  'To ensure Defender Kids functions properly, please grant the following permissions.'),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Help Center',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 20),
              _buildPermissionTile(Icons.mic, 'Usage Limits',
                  'Limit app usage and screen time on this device'),
              _buildPermissionSwitch(
                  'Accessibility Permissions', openAccessibilitySettings),
              _buildPermissionSwitch(
                  'Allow Display Over Other Apps', openOverlaySettings),
              Divider(),
              _buildPermissionTile(Icons.camera_alt, 'Remote Camera',
                  'View your child\'s surroundings through this device\'s camera'),
              _buildPermissionSwitch(
                  'Camera Permission', requestCameraPermission),
              Divider(),
              _buildPermissionTile(Icons.volume_up_rounded, 'One-Way Audio',
                  'Listen to the phone sounds around this device'),
              _buildPermissionSwitch(
                  'Microphone Permission', requestMicrophonePermission),
              Divider(),
              _buildPermissionTile(Icons.microwave, 'Device Activity',
                  'Gain app notifications on your child\'s app usage and screen time'),
              _buildPermissionSwitch(
                  'User Usage Permission', openUsageAccessSettings),
              _buildPermissionSwitch(
                  'Phone Permission', requestPhonePermission),
              Divider(),
              _buildPermissionTile(Icons.notifications, 'Sync Notifications',
                  'View app notifications on your child\'s device in real-time'),
              _buildPermissionSwitch(
                  'Access Notification', openNotificationAccessSettings),
              Divider(),
              _buildPermissionTile(Icons.location_on, 'Location Tracker',
                  'Find this device and set a geofence on it'),
              _buildPermissionSwitch(
                  'Location Permission', requestLocationPermission),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Text color
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 32.0), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to create a ListTile for permissions
  Widget _buildPermissionTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(
            icon,
            color: Colors.white,
          )),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
    );
  }

  /// Helper method to create a switch row with navigation
  Widget _buildPermissionSwitch(String title, Function onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 70),
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(),
              child: Text(
                title,
              ),
            ),
          ),
          Switch(
            value: permissionStatus[title]! ,
            onChanged: (newValue) {
              setState(() {
                permissionStatus[title] = newValue;
              });
              _savePermissionState(title, newValue); // Save the state
              onTap(); // Navigate to settings when toggled
            },
          ),
        ],
      ),
    );
  }

  /// Opens Accessibility Settings
  Future<void> openAccessibilitySettings() async {
    try {
      print("Attempting to open Accessibility Settings...");
      final intent = AndroidIntent(
        action: "android.settings.ACCESSIBILITY_SETTINGS",
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    } catch (e) {
      print("Error launching Accessibility Settings: $e");

      // Alternative method for MIUI devices
      final miuiIntent = AndroidIntent(
        action: "miui.intent.action.ACCESSIBILITY_SETTINGS",
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await miuiIntent.launch();
    }
  }

  /// Opens "Display Over Other Apps" settings
  void openOverlaySettings() {
    final intent = AndroidIntent(
      action: "android.settings.action.MANAGE_OVERLAY_PERMISSION",
      data: "package:${'com.info.defenders'}", // Replace with your app's package name
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  /// Opens Usage Access settings
  void openUsageAccessSettings() {
    final intent = AndroidIntent(
      action: "android.settings.USAGE_ACCESS_SETTINGS",
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  /// Opens Notification Access settings
  void openNotificationAccessSettings() {
    final intent = AndroidIntent(
      action: "android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS",
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  /// Requests Camera Permission
  Future<void> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    setState(() {
      permissionStatus['Camera Permission'] = status.isGranted;
    });
    _savePermissionState(
        'Camera Permission', status.isGranted); // Save the state
  }

  /// Requests Microphone Permission
  Future<void> requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    setState(() {
      permissionStatus['Microphone Permission'] = status.isGranted;
    });
    _savePermissionState(
        'Microphone Permission', status.isGranted); // Save the state
  }

  /// Requests Phone Permission
  Future<void> requestPhonePermission() async {
    PermissionStatus status = await Permission.phone.request();
    setState(() {
      permissionStatus['Phone Permission'] = status.isGranted;
    });
    _savePermissionState(
        'Phone Permission', status.isGranted); // Save the state
  }

  /// Requests Location Permission
  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    setState(() {
      permissionStatus['Location Permission'] = status.isGranted;
    });
    _savePermissionState(
        'Location Permission', status.isGranted); // Save the state
  }
}
