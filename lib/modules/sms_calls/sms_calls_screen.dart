import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../call_log/call_log.dart';

class SmsCalls_Screen extends StatefulWidget {
  @override
  _SmsCalls_ScreenState createState() => _SmsCalls_ScreenState();
}

class _SmsCalls_ScreenState extends State<SmsCalls_Screen> {
  bool phonePermission = false;
  bool contactsPermission = false;
  bool smsPermission = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _checkPermissions();
  }

  // Load saved permission preferences from SharedPreferences
  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phonePermission = prefs.getBool('phonePermission') ?? false;
      contactsPermission = prefs.getBool('contactsPermission') ?? false;
      smsPermission = prefs.getBool('smsPermission') ?? false;
    });
  }

  // Save permission states to SharedPreferences
  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('phonePermission', phonePermission);
    prefs.setBool('contactsPermission', contactsPermission);
    prefs.setBool('smsPermission', smsPermission);
  }

  // Check the current status of permissions
  Future<void> _checkPermissions() async {
    var phoneStatus = await Permission.phone.status;
    var contactsStatus = await Permission.contacts.status;
    var smsStatus = await Permission.sms.status;

    setState(() {
      phonePermission = phoneStatus.isGranted;
      contactsPermission = contactsStatus.isGranted;
      smsPermission = smsStatus.isGranted;
    });

    _savePreferences(); // Save permission states
  }

  // Function to request permission
  Future<void> _requestPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    setState(() {
      if (permission == Permission.phone) {
        phonePermission = status.isGranted;
      } else if (permission == Permission.contacts) {
        contactsPermission = status.isGranted;
      } else if (permission == Permission.sms) {
        smsPermission = status.isGranted;
      }
    });
    _savePreferences(); // Save permission state
  }

  // Navigate to the system settings for a specific permission
  Future<void> _openSettings(Permission permission) async {
    if (await permission.isDenied) {
      await openAppSettings();
    }
  }

  // Function to enable all permissions
  Future<void> _enableAllPermissions() async {
    await _requestPermission(Permission.phone);
    await _requestPermission(Permission.contacts);
    await _requestPermission(Permission.sms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Calls & SMS Monitoring'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Granting the required permissions allows your guardian to monitor your calls and SMS and enhance security.',
            ),
            SizedBox(height: 20),
            _buildPermissionTile(
              icon: Icons.phone,
              title: 'Phone Permission',
              value: phonePermission,
              onChanged: (newValue) {
                if (newValue) {
                  _requestPermission(Permission.phone);
                } else {
                  _openSettings(Permission.phone);  // Open settings if permission denied
                }
              },
            ),
            _buildPermissionTile(
              icon: Icons.contacts,
              title: 'Contacts Permission',
              value: contactsPermission,
              onChanged: (newValue) {
                if (newValue) {
                  _requestPermission(Permission.contacts);
                } else {
                  _openSettings(Permission.contacts);  // Open settings if permission denied
                }
              },
            ),
            _buildPermissionTile(
              icon: Icons.message,
              title: 'SMS Permission',
              value: smsPermission,
              onChanged: (newValue) {
                if (newValue) {
                  _requestPermission(Permission.sms);
                } else {
                  _openSettings(Permission.sms);  // Open settings if permission denied
                }
              },
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallSmsScreen()), // Navigate to CallSmsScreen
                );
              },
              child: ListTile(
                leading: Icon(Icons.call_outlined),
                title: Text('Call & SMS'),
                trailing:Icon(Icons.arrow_forward)
              ),
            ),


            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                onPressed: () {
                  _enableAllPermissions(); // Request all permissions when "Enable" is clicked
                },
                child: Text('Enable'),
              ),

            ),
            Center(
              child: TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('Skip'),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
