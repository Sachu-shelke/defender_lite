// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ScanCode extends StatefulWidget {
//   const ScanCode({super.key});
//
//   @override
//   State<ScanCode> createState() => _ScanCodeState();
// }
//
// class _ScanCodeState extends State<ScanCode> {
//   String? scannedData;
//
//   // Function to launch URL
//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   // Function to scan QR code
//   Future<void> scanQRCode() async {
//     String barcodeScanResult;
//     try {
//       barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
//         "#ff6666", // Color for scan button
//         "Cancel", // Cancel button text
//         true, // Show flash icon
//         ScanMode.QR, // Scan mode: QR Code only
//       );
//
//       if (barcodeScanResult != "-1") {
//         setState(() {
//           scannedData = barcodeScanResult;
//         });
//
//         if (Uri.tryParse(barcodeScanResult)?.hasAbsolutePath == true) {
//           _launchURL(barcodeScanResult);
//         }
//       }
//     } catch (e) {
//       setState(() {
//         scannedData = "Failed to scan QR code.";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Scan QR Code")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               scannedData ?? "Press the button to scan a QR code",
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: scanQRCode,
//               child: Text("Scan QR Code"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
