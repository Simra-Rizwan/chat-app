import 'package:chat_app/first_screen.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/widgets/cached_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser chatUser;

  const ChatScreen({super.key, required this.chatUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _messageController;
  final ChatProvider chatService = ChatProvider();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;
    String temp = _messageController.text.trim();
    _messageController.clear();
    chatService.sendMessage(
      receiverId: widget.chatUser.receiverUserId!,
      message: temp,
      senderName: widget.chatUser.senderName ?? "Notification",
      receiverFCMToken: widget.chatUser.fcmToken ?? "",
    );
  }

  @override
  void initState() {
    _messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FirstScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: Text(
          widget.chatUser.name ?? "User",
          style: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.normal,
              fontSize: 26,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: CachedImage(
              borderRadius: 100,
              imageUrl: widget.chatUser.imageURL,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: Image.asset(
              "assets/images/chat_app_image.jpg",
              fit: BoxFit.cover,
              width: width,
              height: height,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: chatService.getMessage(
                    userId: widget.chatUser.receiverUserId!,
                    otherUserId: _firebaseAuth.currentUser!.uid,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Error");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, index) {
                        final message = snapshot.data!.docs.reversed.toList()[index];
                        final data = message.data() as Map<String, dynamic>;

                        final MessageModel messageModel = MessageModel.fromMap(data);
                        bool isSender = messageModel.senderId == _firebaseAuth.currentUser!.uid;

                        return Align(
                          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isSender ? Colors.blue : Colors.grey[300],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isSender
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  messageModel.message ?? "",
                                  style: TextStyle(
                                    color: isSender ? Colors.white : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                    DateFormat("hh:mm a")
                                        .format((messageModel.timestamp!.toDate()),
                                    ),
                                  style: TextStyle(
                                    color: isSender ? Colors.white70 : Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                          ),
                          hintText: "Type a message",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
