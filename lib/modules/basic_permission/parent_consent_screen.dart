import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../binding/binding_screen.dart';

class ParentalConsentScreen extends StatefulWidget {
  @override
  _ParentalConsentScreenState createState() => _ParentalConsentScreenState();
}

class _ParentalConsentScreenState extends State<ParentalConsentScreen> {
  @override
  void initState() {
    super.initState();
    _setHasOpenedBefore();
  }

  // Set 'hasOpenedBefore' flag to true when the consent screen is initialized
  _setHasOpenedBefore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasOpenedBefore', true); // Setting the flag to true
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// Content Section
          Expanded(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Image Banner
                    Container(
                      height: 150,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Image.asset(
                        'assets/sticker/communications.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    /// Main Text
                    Text(
                      'You confirm that, as the guardian or legal agent of the device, you have installed the App for your child, and agree and authorize our products to obtain the data and information of your child\'s device.',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 20),

                    /// Terms & Privacy Policy
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6)),
                        children: <TextSpan>[
                          TextSpan(text: 'Before you continue to use our services, you have read and fully understood our '),
                          TextSpan(text: 'Terms of Service', style: TextStyle(color: Colors.blue)),
                          TextSpan(text: ' and '),
                          TextSpan(text: 'Privacy Policy', style: TextStyle(color: Colors.blue)),
                          TextSpan(text: '. You expressly undertake to comply with the applicable laws and regulations in your territory during the use of the application.'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    /// Legal Disclaimer
                    Text(
                      'You understand that illegal surveillance and recording activities without lawful authorization may be considered criminal acts and subject to legal liability.',
                      style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () async {
                  // Mark that Parental Consent screen has been shown
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isFirstTimeConsent', false);

                  // Navigate to the next screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BindingScreen()),
                  );
                },
                child: Text(
                  'Accept',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
