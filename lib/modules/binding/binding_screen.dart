import 'package:defender_lite/modules/profile/child_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/dailoag_box/binding_dailoagbox.dart';

class BindingScreen extends StatefulWidget {
  @override
  _BindingScreenState createState() => _BindingScreenState();
}

class _BindingScreenState extends State<BindingScreen> {
  final TextEditingController _bindingCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyShown();
  }

  Future<void> _checkIfAlreadyShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenBindingScreen = prefs.getBool('hasSeenBindingScreen') ?? false;

    if (hasSeenBindingScreen) {
      _navigateToNextScreen();
    } else {
      await prefs.setBool('hasSeenBindingScreen', true);
    }
  }

  void _navigateToNextScreen() {
    Get.off(() => ChildProfileScreen()); // Replaces current screen
  }

  void _validateAndProceed() {
    if (_bindingCodeController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a valid binding code",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      _navigateToNextScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset('assets/sticker/family.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 20),
            const Text(
              "Join Your Family Group",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter the binding code from the guardian's AirDroid Parental Control",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _bindingCodeController,
              decoration: InputDecoration(
                labelText: "Binding Code",
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _showBindingDialog,
              child: const Text(
                "Where can I get the binding code?",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _validateAndProceed,
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBindingDialog() {
    (showBindingDialog(context));
  }
}
