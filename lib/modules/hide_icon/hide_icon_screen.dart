import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class HideIconScreen extends StatefulWidget {
  @override
  _HideIconScreenState createState() => _HideIconScreenState();
}

class _HideIconScreenState extends State<HideIconScreen> {
  final String secretCode = "*#*#426548#*#*"; // Secret dial code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Hide Icon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 150,
                width: double.infinity,
                child: Image.asset(
                  'assets/sticker/secure.png',
                  fit: BoxFit.cover,
                )),
            Text('To open the hidden Defender Kids, dial the code:'),
            SizedBox(height: 20),
            Center(
              child: Text(secretCode,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await hideAppIcon();
                    Navigator.pop(context); // Close the screen
                  },
                  child: Text('Hide and continue'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Keep it visible'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Hide the app icon by disabling the launcher activity
  Future<void> hideAppIcon() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('icon_hidden', true);

    final intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      componentName: 'com.info.defenders/.MainActivity',
      package: 'com.info.defenders',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();

    Process.run("pm", ["disable", "com.info.defenders/.MainActivity"]);
  }
}
