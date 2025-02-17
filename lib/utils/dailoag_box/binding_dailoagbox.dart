import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showBindingDialog(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? bindingCode = prefs.getString('binding_code');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
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
                        Text(
                          "Where can I get the binding code?",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            children: [
                              TextSpan(text: "Please open "),
                              TextSpan(
                                text: "Defender Parental Control",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text:
                                  ", then follow the instructions to add devices and get the binding code."),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                size: 18, color: Colors.black54),
                            SizedBox(width: 5),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: [
                                    TextSpan(
                                        text:
                                        "If the guardian has not installed "),
                                    TextSpan(
                                      text: "Defender Parental Control",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                        text:
                                        " on their device, please download it via "),
                                    TextSpan(
                                      text: "apps.Defender.com/parentalcontrol",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    TextSpan(
                                        text: " or scan the QR code below."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),

                        // ✅ QR Code Display
                        if (bindingCode != null) ...[
                          Text(
                            "Binding Code: $bindingCode",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          PrettyQr(
                            data: bindingCode,
                            size: 120.0,
                            errorCorrectLevel: QrErrorCorrectLevel.M,
                            roundEdges: true,
                          ),
                        ] else
                          Text("No binding code available",
                              style: TextStyle(color: Colors.red)),

                        SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text("OK",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.green.shade200,
                      radius: 24,
                      child:
                      Icon(Icons.lightbulb, color: Colors.orange, size: 28),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
