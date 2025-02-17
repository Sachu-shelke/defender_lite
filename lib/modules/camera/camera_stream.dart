import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CameraSenderPage extends StatefulWidget {
  final String wsUrl;

  CameraSenderPage({required this.wsUrl});

  @override
  _CameraSenderPageState createState() => _CameraSenderPageState();
}

class _CameraSenderPageState extends State<CameraSenderPage> {
  CameraController? _controller;
  WebSocketChannel? _channel;
  bool _isStreaming = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    setState(() {});
    _startStreaming(); // Automatically start streaming
  }

  void _startStreaming() {
    if (_isStreaming) return;

    _channel = WebSocketChannel.connect(Uri.parse(widget.wsUrl));
    _isStreaming = true;

    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (!_controller!.value.isInitialized) return;
      final XFile imageFile = await _controller!.takePicture();
      final Uint8List imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      _channel!.sink.add(base64Image);
    });
  }

  void _stopStreaming() {
    _timer?.cancel();
    _channel?.sink.close();
    setState(() {
      _isStreaming = false;
    });
  }

  @override
  void dispose() {
    _stopStreaming();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera Stream Sender")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _controller != null && _controller!.value.isInitialized
              ? CameraPreview(_controller!)
              : CircularProgressIndicator(),
          SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: _stopStreaming,
          //   child: Text("Stop Streaming"),
          // ),
        ],
      ),
    );
  }
}
