// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class WebRTCChild {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;
//   String roomId = "audio_room"; // Shared room ID
//
//   Future<void> startCall() async {
//     // Setup ICE servers
//     var config = {
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//       ]
//     };
//
//     _peerConnection = await createPeerConnection(config);
//
//     // Capture audio from microphone
//     _localStream = await navigator.mediaDevices.getUserMedia({'audio': true});
//     _localStream!.getTracks().forEach((track) {
//       _peerConnection!.addTrack(track, _localStream!);
//     });
//
//     // Listen for ICE candidates and send to Firestore
//     _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
//       _firestore.collection("calls/$roomId/candidates").add(candidate.toMap());
//     };
//
//     // Create an offer and save to Firestore
//     RTCSessionDescription offer = await _peerConnection!.createOffer();
//     await _peerConnection!.setLocalDescription(offer);
//     await _firestore
//         .collection("calls")
//         .doc(roomId)
//         .set({'offer': offer.toMap()});
//   }
//
//   // Listen for an answer from the parent device
//   Future<void> listenForAnswer() async {
//     _firestore
//         .collection("calls")
//         .doc(roomId)
//         .snapshots()
//         .listen((snapshot) async {
//       if (snapshot.exists && snapshot.data()!.containsKey('answer')) {
//         RTCSessionDescription answer = RTCSessionDescription(
//           snapshot.data()!['answer']['sdp'],
//           snapshot.data()!['answer']['type'],
//         );
//         await _peerConnection!.setRemoteDescription(answer);
//       }
//     });
//   }
//
//   // Listen for incoming ICE candidates
//   Future<void> listenForICECandidates() async {
//     _firestore
//         .collection("calls/$roomId/candidates")
//         .snapshots()
//         .listen((snapshot) {
//       for (var change in snapshot.docChanges) {
//         if (change.type == DocumentChangeType.added) {
//           var data = change.doc.data();
//           RTCIceCandidate candidate = RTCIceCandidate(
//               data?['candidate'], data?['sdpMid'], data?['sdpMLineIndex']);
//           _peerConnection!.addCandidate(candidate);
//         }
//       }
//     });
//   }
// }
