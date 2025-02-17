import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/child_profile.dart';

class QrCodeScreen extends StatefulWidget {
  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final TextEditingController _bindingCodeController = TextEditingController();
  String? qrdata;

  @override
  void initState() {
    super.initState();
    _checkIfBindingIsCompleted();
  }

  // Check if the user has already completed binding before
  _checkIfBindingIsCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasCompletedBinding = prefs.getBool('hasCompletedBinding') ?? false;

    if (hasCompletedBinding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChildProfileScreen()),
      );
    }
  }

  // Function to validate the binding code before navigating
  void _validateBindingCode(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasCompletedBinding', true);

    // Navigate to the next onboarding screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChildProfileScreen()),
    );
  }

  // Show QR Code in Dialog
  void _showQRCodeDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bindingCode = prefs.getString('binding_code');

    if (bindingCode == null) {
      bindingCode = await _generateBindingCode();
    }

    setState(() {
      qrdata = bindingCode;
    });
  }

  // Generate a unique binding code and store it
  Future<String> _generateBindingCode() async {
    String bindingCode = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString(); // 6-digit code
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('binding_code', bindingCode);
    return bindingCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Binding Code Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shadowColor: Colors.black,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  onPressed: _showQRCodeDialog,
                  child: Text('Generate QR Code\nAnd Binding Code',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Display the Binding Code Text and QR Code
            if (qrdata != null) ...[
              Text(
                'Binding Code: $qrdata',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Center(
                child: PrettyQr(
                  data: qrdata!,
                  size: 200.0,
                  errorCorrectLevel: QrErrorCorrectLevel.M,
                  roundEdges: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
