import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Installed Services'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'To ensure Defender Kids functions properly, please enable Defender Kids within the accessibility menu.'),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.accessibility),
              title: Text('Defender Kids'),
              subtitle:
                  Text('Enable Defender Kids within the accessibility menu'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // Navigator.pushNamed(
            //     context, '/permissions'); // Navigate to the next screen
          },
          child: Text('Next'),
        ),
      ],
    );
  }
}
