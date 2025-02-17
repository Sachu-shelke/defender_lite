import 'package:flutter/material.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.asset('assets/sticker/good.png', fit: BoxFit.contain),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Parental Consent',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'You confirm that, as the guardian or legal agent of the device, you have installed the App for your child, and agree and authorize our product to obtain the data and information of your child\'s device.',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(text: 'Before you continue to use our services, you have read and fully understood our '),
                      TextSpan(
                        text: 'Terms and Services',
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                      TextSpan(text: ' You expressly undertake to comply with the applicable laws and regulations in your territory during the use of the application.'),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'You understand that illegal surveillance and recording activities without lawful authorization may be considered criminal acts and subject to liability.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const BindingCodeDialogBox();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Accept', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BindingCodeDialogBox extends StatelessWidget {
  const BindingCodeDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    children: [
                      const Text(
                        "Where can I get the binding code?",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(text: "Please open "),
                            TextSpan(
                              text: "Defender Parental Control",
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ", then follow the instructions to add devices and get the binding code."),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, size: 18, color: Colors.black54),
                          const SizedBox(width: 5),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(color: Colors.black, fontSize: 14),
                                children: [
                                  TextSpan(text: "If the guardian has not installed "),
                                  TextSpan(
                                    text: "Defender Parental Control",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: " on their device, please download it via "),
                                  TextSpan(
                                    text: "apps.defender.com/parentalcontrol",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  TextSpan(text: " or scan the QR code below."),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // QR Code Container (Enable when needed)
                      // Container(
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(color: Colors.black12),
                      //   ),
                      //   padding: const EdgeInsets.all(10),
                      //   child: Image.asset('assets/qr_code.png', height: 100, width: 100),
                      // ),
                      const SizedBox(height: 5),
                      const Text("- QR Code -", style: TextStyle(color: Colors.black54)),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("OK", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -1,
                  child: CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    radius: 15,
                    child: const Icon(Icons.lightbulb, color: Colors.orange, size: 15),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
