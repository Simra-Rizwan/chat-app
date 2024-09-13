import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? senderId;  //one sending the msg
  final String? senderEmail;
  final String? receiverId; //login person receiving the msg
  final String? message;
  final Timestamp? timestamp;
  MessageModel({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      senderEmail:
      map['senderEmail'] != null ? map['senderEmail'] as String : null,
      receiverId:
      map['receiverId'] != null ? map['receiverId'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      timestamp: map['timestamp'],
    );
  }
}