import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendAppUsageToServer(List<Map<String, dynamic>> usageData) async {
  final Uri apiUrl = Uri.parse('https://yourserver.com/app_usage');

  try {
    var response = await http.post(
      apiUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"device_id": "DEVICE_UNIQUE_ID", "usage": usageData}),
    );

    if (response.statusCode == 200) {
      print("App usage data sent successfully.");
    } else {
      print("Failed to send app usage data: ${response.statusCode}");
    }
  } catch (e) {
    print("Error sending data: $e");
  }
}
