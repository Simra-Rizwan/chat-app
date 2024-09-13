import 'message_model.dart';

class ChatUser {
  final String? name;
  final String? imageURL;
  final bool? isRead;
  final String? receiverUserEmail; //receiver is login person(me)
  final String? receiverUserId;
  final String? senderName;
  final MessageModel? lastMessage;
  final String? fcmToken;

  ChatUser({
    required this.name,
    required this.imageURL,
    required this.isRead,
    required this.receiverUserId,
    required this.receiverUserEmail,
    required this.senderName,
    required this.lastMessage,
    required this.fcmToken,
  });
}
