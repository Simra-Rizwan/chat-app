import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message_model.dart';

class ChatProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      {required String receiverId,
      required String message,
      required String receiverFCMToken,
      required String senderName}) async {
    try{
      final String currentUserId = _firebaseAuth.currentUser!.uid;
      final String currentUserEmail = _firebaseAuth.currentUser!.email!;
      final Timestamp timestamp = Timestamp.now();

      MessageModel newMessage = MessageModel(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
      );
      //joining the ids of sender and receiver
      List<String> ids = [currentUserId, receiverId];
      ids.sort();
      String chatRoomId = ids.join("_");
      _firestore
          .collection("chat_room")
          .doc(chatRoomId)
          .collection("message")
          .add(
        newMessage.toMap(),
      );
    } catch(e){
      print("EXCEPTION");
      print(e);
    }

  }

  Stream<QuerySnapshot> getMessage({
    required String userId,
    required String otherUserId,
  }) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("message")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
