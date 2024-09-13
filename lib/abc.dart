// import 'dart:async';
//
// import 'package:chat_app/providers/auth_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'models/chat_user.dart';
// import 'models/message_model.dart';
// import 'models/user_model.dart';
//
// class ConversationsListingScreen extends StatefulWidget {
//   const ConversationsListingScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ConversationsListingScreen> createState() =>
//       _ConversationsListingScreenState();
// }
//
// class _ConversationsListingScreenState
//     extends State<ConversationsListingScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const CustomDrawer(),
//       body: CustomScrollView(
//         slivers: [
//           const FloatingAppBar(title: 'Messaging'),
//           SliverList(
//             delegate: SliverChildListDelegate(
//               <Widget>[
//                 StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection("users")
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasError) {
//                       return const Text("error");
//                     }
//
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Padding(
//                         padding: EdgeInsets.only(top: 50.0),
//                         child: Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       );
//                     }
//
//                     UserModel? currentUser = context.watch<AuthProvider>().user;
//                     if (currentUser == null) {
//                       context.read<AuthProvider>().fetchUserData();
//                       return const Padding(
//                         padding: EdgeInsets.only(top: 50.0),
//                         child: Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       );
//                     }
//
//                     return FutureBuilder<List<ChatUser>>(
//                       future: _buildChatUsers(currentUser, snapshot.data!.docs),
//                       builder: (context, futureSnapshot) {
//                         if (futureSnapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Padding(
//                             padding: EdgeInsets.only(top: 50.0),
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           );
//                         }
//
//                         List<ChatUser> _myChats = futureSnapshot.data ?? [];
//                         _myChats.sort((a, b) =>
//                             (b.lastMessage!.timestamp!.toDate())
//                                 .compareTo(a.lastMessage!.timestamp!.toDate()));
//
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 16.0),
//                           child: Column(
//                             children: _myChats.map((chat) {
//                               return ConversationItem(chatUser: chat);
//                             }).toList(),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Future<List<ChatUser>> _buildChatUsers(
//       UserModel currentUser,
//       List<QueryDocumentSnapshot<Object?>> docs,
//       ) async {
//     List<ChatUser> _myChats = [];
//
//     for (var userDoc in docs) {
//       final Map<String, dynamic> _data =
//       userDoc.data()! as Map<String, dynamic>;
//       UserModel _user = UserModel.fromMap(_data);
//       if (currentUser.id != _user.id) {
//         List<String> ids = [currentUser.id!, _user.id!];
//         ids.sort();
//
//         String chatRoomId = ids.join("_");
//
//         var value = await FirebaseFirestore.instance
//             .collection("chat_rooms")
//             .doc(chatRoomId)
//             .collection("messages")
//             .orderBy("timestamp", descending: false)
//             .get();
//
//         MessageModel? lastMessage =
//         MessageModel.fromMap(value.docs.last.data());
//
//         _myChats.add(
//           ChatUser(
//               receiverUserName: context.read<AuthProvider>().displayName,
//               name: "${_user.firstName ?? ""} ${_user.lastName ?? ""}",
//               imageURL: _user.avatar,
//               isRead: true,
//               receiverUserId: _user.id,
//               receiverUserEmail: _user.email,
//               lastMessage: lastMessage,
//               fcmToken: _user.fcmToken),
//         );
//       }
//     }
//
//     return _myChats;
//   }
// }