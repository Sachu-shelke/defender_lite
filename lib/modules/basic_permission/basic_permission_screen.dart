import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

class BasicPermissionScreen extends StatefulWidget {
  @override
  _BasicPermissionScreenState createState() => _BasicPermissionScreenState();
}

class _BasicPermissionScreenState extends State<BasicPermissionScreen> {
  Map<String, bool> permissionStatus = {
    'Device Admin Permission': false,
    'Ignore Battery Optimization': false,
    'Allow pop-ups in the background': false,
    'Allow auto-start': false,
    'Disable power-saving mode': false,
  };

  @override
  void initState() {
    super.initState();
    _loadPermissionStatus();
  }

  _loadPermissionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      permissionStatus.forEach((key, value) {
        permissionStatus[key] = prefs.getBool(key) ?? false;
      });
    });
  }

  _savePermissionStatus(String title, bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(title, status);
  }

  _toggleAllPermissions(bool enable) {
    setState(() {
      permissionStatus.updateAll((key, value) => enable);
    });
    permissionStatus.forEach((key, value) async {
      await _savePermissionStatus(key, enable);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool allEnabled = permissionStatus.values.every((status) => status);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Keep Running in Background'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text('Grant the below permissions to keep Defender Lite running in the background.'),
            SizedBox(height: 20),
            for (var entry in permissionStatus.entries)
              _buildPermissionTile(entry.key, entry.value),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _toggleAllPermissions(!allEnabled);
                },
                child: Text(allEnabled ? 'Disable' : 'Enable'),
              ),
            ),
              Center(
                child: TextButton(
                        onPressed: () {
                          Get.back();
                          },
                      child: Text('Back',style: TextStyle(color: Colors.grey,),),
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile(String title, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Switch(
            value: status,
            onChanged: (newValue) {
              setState(() {
                permissionStatus[title] = newValue;
                _savePermissionStatus(title, newValue);
              });
              if (newValue) {
                _openSettings(title);
              }
            },
          ),
        ],
      ),
    );
  }

  void _openSettings(String title) {
    AndroidIntent intent;
    switch (title) {
      case 'Device Admin Permission':
        intent = AndroidIntent(action: "android.settings.SECURITY_SETTINGS", flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
        break;
      case 'Ignore Battery Optimization':
        intent = AndroidIntent(action: "android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS", flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
        break;
      case 'Allow pop-ups in the background':
        intent = AndroidIntent(action: "android.settings.MANAGE_OVERLAY_PERMISSION", data: "package:com.info.defenders", flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
        break;
      case 'Allow auto-start':
        _openAutoStartSettings();
        return;
      case 'Disable power-saving mode':
        intent = AndroidIntent(action: "android.settings.BATTERY_SAVER_SETTINGS", flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
        break;
      default:
        return;
    }
    intent.launch();
  }

  void _openAutoStartSettings() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String manufacturer = androidInfo.manufacturer.toLowerCase();

    AndroidIntent intent;
    if (manufacturer.contains("xiaomi")) {
      intent = AndroidIntent(action: "miui.intent.action.OP_AUTO_START", flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
    } else if (manufacturer.contains("oppo") || manufacturer.contains("realme")) {
      intent = AndroidIntent(action: "com.coloros.safecenter.permission.startup.StartupAppListActivity", flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
    } else if (manufacturer.contains("vivo")) {
      intent = AndroidIntent(action: "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager", flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
    } else if (manufacturer.contains("huawei")) {
      intent = AndroidIntent(action: "huawei.intent.action.HSM_BOOTAPP_MANAGER", flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
    } else {
      intent = AndroidIntent(action: "android.settings.APPLICATION_DETAILS_SETTINGS", data: "package:com.info.defenders", flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
    }
    intent.launch();
  }
}
