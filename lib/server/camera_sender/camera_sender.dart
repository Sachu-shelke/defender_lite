import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraStreamApp extends StatefulWidget {
  @override
  _CameraStreamAppState createState() => _CameraStreamAppState();
}

class _CameraStreamAppState extends State<CameraStreamApp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isStreaming = false;
  late WebSocketChannel _webSocketChannel;

  @override
  void initState() {
    super.initState();
    requestPermissions().then((granted) {
      if (granted) {
        initializeCamera(); // Initialize camera once permission is granted
        connectToServer();  // Connect to WebSocket server
      }
    });
  }

  // Request Camera Permission
  Future<bool> requestPermissions() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }

  // Initialize Camera
  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  // Connect to WebSocket Server
  Future<void> connectToServer() async {
    try {
      _webSocketChannel = WebSocketChannel.connect(Uri.parse('ws://yourserver.com/video'));
      print('Connected to WebSocket server');
    } catch (e) {
      print('Failed to connect: $e');
    }
  }

  // Start Video Streaming
  Future<void> startStreaming() async {
    await _initializeControllerFuture;

    // Start the camera preview and capture frames
    _controller.startImageStream((CameraImage image) {
      if (_isStreaming) {
        sendFrameToServer(image);
      }
    });

    setState(() {
      _isStreaming = true;
    });
  }

  // Stop Video Streaming
  Future<void> stopStreaming() async {
    await _controller.stopImageStream();
    setState(() {
      _isStreaming = false;
    });
  }

  // Send Frame to Server (Convert Camera Image to JPEG)
  Future<void> sendFrameToServer(CameraImage image) async {
    try {
      final bytes = await _convertImageToBytes(image);
      _webSocketChannel.sink.add(bytes); // Send frame data to the WebSocket server
        } catch (e) {
      print('Error sending frame: $e');
    }
  }

  // Convert CameraImage to JPEG or any other suitable format
  Future<Uint8List> _convertImageToBytes(CameraImage image) async {
    return image.planes.first.bytes;
  }

  @override
  void dispose() {
    stopStreaming();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Defender Lite - Real-time Camera Stream')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _isStreaming
                  ? ElevatedButton(
                  onPressed: stopStreaming,
                  child: Text("Stop Streaming"))
                  : ElevatedButton(
                  onPressed: startStreaming,
                  child: Text("Start Streaming")),
              // Display the camera preview
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
