import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class AudioStreamApp extends StatefulWidget {
  @override
  _AudioStreamAppState createState() => _AudioStreamAppState();
}

class _AudioStreamAppState extends State<AudioStreamApp> {
  FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false;
  WebSocketChannel? _webSocketChannel;
  StreamController<Uint8List>? _audioStreamController;

  @override
  void initState() {
    super.initState();
    _initializeAudioStreaming();
  }

  // Request Microphone Permission
  Future<bool> requestPermissions() async {
    var status = await Permission.microphone.request();
    return status.isGranted;
  }

  // Initialize WebSocket & Recording
  Future<void> _initializeAudioStreaming() async {
    bool granted = await requestPermissions();
    if (!granted) {
      print('Microphone permission denied. Retrying in 5 seconds...');
      Future.delayed(Duration(seconds: 5), _initializeAudioStreaming);
      return;
    }

    await connectToServer();
    await startRecording();
  }

  // Connect to WebSocket server
  Future<void> connectToServer() async {
    try {
      _webSocketChannel = WebSocketChannel.connect(Uri.parse('ws://yourserver.com/audio')); // Update with actual server URL
      print('Connected to WebSocket server');
    } catch (e) {
      print('Failed to connect: $e. Retrying in 5 seconds...');
      Future.delayed(Duration(seconds: 5), connectToServer);
    }
  }

  // Start Recording and Streaming Audio
  Future<void> startRecording() async {
    if (_audioRecorder.isStopped) {
      await _audioRecorder.openRecorder();
    }

    _audioStreamController = StreamController<Uint8List>();
    _audioStreamController!.stream.listen(sendAudioDataToServer);

    await _audioRecorder.startRecorder(
      codec: Codec.pcm16,
      toStream: _audioStreamController!.sink, // Use StreamController
    );

    setState(() => _isRecording = true);
    print("Recording started...");
  }

  // Stop Recording
  Future<void> stopRecording() async {
    if (!_audioRecorder.isStopped) {
      await _audioRecorder.stopRecorder();
      _audioStreamController?.close();
      setState(() => _isRecording = false);
      print("Recording stopped.");
    }
  }

  // Send Audio Data to WebSocket Server
  void sendAudioDataToServer(Uint8List audioData) {
    if (_webSocketChannel != null) {
      _webSocketChannel!.sink.add(audioData);
    } else {
      print('WebSocket is not connected!');
    }
  }

  @override
  void dispose() {
    if (_isRecording) {
      stopRecording();
    }
    _audioRecorder.closeRecorder();
    _webSocketChannel?.sink.close();
    _audioStreamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Defender Lite - Auto Audio Streaming')),
        body: Center(
          child: Text(_isRecording ? "Streaming Audio..." : "Waiting for permissions..."),
        ),
      ),
    );
  }
}
