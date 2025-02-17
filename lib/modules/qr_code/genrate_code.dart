import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class GenrateCode extends StatefulWidget {
  const GenrateCode({super.key});

  @override
  State<GenrateCode> createState() => _GenrateCodeState();
}

class _GenrateCodeState extends State<GenrateCode> {
  String? qrdata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) {
                setState(() {
                  qrdata = value;
                });
              },
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 200,),
                  if (qrdata != null)
                    Center(
                      child: PrettyQr(
                        data: qrdata!,
                        size: 200.0, // You can adjust the size as per your requirement
                        errorCorrectLevel: QrErrorCorrectLevel.M, // Optional
                        roundEdges: true, // Optional, to give rounded corners to the QR code
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
