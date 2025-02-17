import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;

import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart' as perm;
import 'dart:convert';

class LocationApp extends StatefulWidget {
  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  var location = loc.Location();
  bool _isLocationPermissionGranted = false;
  bool _isLocationAvailable = false;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  // Request location permission
  Future<void> requestLocationPermission() async {
    perm.PermissionStatus status = await perm.Permission.location.request();

    if (status.isGranted) {
      setState(() {
        _isLocationPermissionGranted = true;
      });
      getLocation();
    } else {
      setState(() {
        _isLocationPermissionGranted = false;
      });
    }
  }

  // Get the current location
  Future<void> getLocation() async {
    try {
      var currentLocation = await location.getLocation();

      // Print the location to console (latitude and longitude)
      print("Latitude: ${currentLocation.latitude}, Longitude: ${currentLocation.longitude}");

      // Send location data to the server
      sendLocationToServer(currentLocation.latitude!, currentLocation.longitude!);

      setState(() {
        _isLocationAvailable = true;
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _isLocationAvailable = false;
      });
    }
  }

  // Send location data to the server
  Future<void> sendLocationToServer(double latitude, double longitude) async {
    final Uri apiUrl = Uri.parse('https://yourserver.com/location');

    try {
      Map<String, dynamic> data = {
        "device_id": "DEVICE_UNIQUE_ID",
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": DateTime.now().toString(),
      };

      var response = await http.post(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Location sent successfully.");
      } else {
        print("Failed to send location: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending location data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Location Sender App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isLocationPermissionGranted
                  ? ElevatedButton(
                onPressed: getLocation,
                child: Text("Get Current Location"),
              )
                  : Text("Location permission is required."),
              SizedBox(height: 20),
              _isLocationAvailable
                  ? Text("Location available and sent successfully.")
                  : Text("Location not available or failed to fetch."),
            ],
          ),
        ),
      ),
    );
  }
}

