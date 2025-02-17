import 'package:flutter/services.dart';

class MyAccessibilityService {
  static const MethodChannel _channel =
  MethodChannel('accessibility_service');

  static Future<bool> isServiceEnabled() async {
    try {
      final bool isEnabled = await _channel.invokeMethod('isAccessibilityEnabled');
      return isEnabled;
    } on PlatformException {
      return false;
    }
  }
}

class AccessibilityService {
  static const MethodChannel _channel = MethodChannel('accessibility_service');

  static Future<bool> isAccessibilityEnabled() async {
    try {
      final bool result = await _channel.invokeMethod('isAccessibilityEnabled');
      return result;
    } on PlatformException catch (e) {
      print("Failed to check accessibility service: '${e.message}'.");
      return false;
    }
  }
}
