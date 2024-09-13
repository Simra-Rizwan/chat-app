import 'package:chat_app/extensions.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/user_profile.dart';
import 'package:chat_app/widgets/cached_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';
import 'models/message_model.dart';
import 'models/user_model.dart';

class FirstScreen extends StatefulWidget {
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";

  void initState() {
    super.initState();
    _searchController.addListener(_searchTextChange);
  }

  void dispose() {
    super.dispose();
    _searchController.removeListener(_searchTextChange);
    _searchController.dispose();
  }

  void _searchTextChange() {
    setState(() {
      searchText = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          "message".capitalize(),
          style: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.normal,
              fontSize: 26,
              fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Consumer<AuthServiceProvider>(builder: (_, authProvider, __) {
        final user = authProvider.user;

        // print(user?.avatar);
        return Drawer(
            child: Column(children: [
          UserAccountsDrawerHeader(
            // currentAccountPicture: Image.network(user?.avatar ?? ""),
            currentAccountPicture: CachedImage(
              borderRadius: 8,
              imageHeight: 100,
              imageWidth: 100,
              imageUrl: user?.avatar ?? "",
              fit: BoxFit.fill,
            ),
            accountName: Text(authProvider.displayName),
            accountEmail: Text(user?.email ?? 'guest@example.com'),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_rounded),
            title: const Text("Personal Information"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text("Chat"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("LogOut"),
            onTap: () async {
              await context.read<AuthServiceProvider>().signOut();
            },
          ),
        ]));
      }),
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
          // Center(
          //   child:
          Consumer<AuthServiceProvider>(builder: (_, authProvider, __) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 40,
                left: 34,
                right: 34,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                        hintText: "Search",
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.grey)),
                        suffixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.black,
                        )),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Error");
                        }

                        //execute if snapshot is fetching users from firestore loading will show
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ));
                        }
                        //fetch the current user
                        UserModel? currentUser = authProvider.user;
                        if (currentUser == null) {
                          authProvider.fetchUserData();
                          return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ));
                        }
                        //
                        return StreamBuilder(
                            stream: _buildChatUsers(
                                context, currentUser, snapshot.data!.docs),
                            builder: (context, futureSnapshot) {
                              if (futureSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ));
                              }
                              //List the users message and sort the messages
                              List<ChatUser> _myChats =
                                  futureSnapshot.data ?? [];
                              _myChats.sort((a, b) {
                                if (a.lastMessage?.timestamp == null ||
                                    b.lastMessage?.timestamp == null) {
                                  return 0;
                                }
                                return (b.lastMessage!.timestamp!.toDate())
                                    .compareTo(
                                  a.lastMessage!.timestamp!.toDate(),
                                );
                              });

                              //TODO: search the user by search text
                              if (searchText.isNotEmpty) {
                                _myChats = _myChats
                                    .where((ChatUser chatItem) =>
                                        chatItem.name?.toLowerCase().contains(
                                            searchText.toLowerCase()) ??
                                        false)
                                    .toList();
                              }

                              return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _myChats.length,
                                  padding: EdgeInsets.zero,
                                  separatorBuilder: (_, __) => const SizedBox(
                                        height: 20,
                                      ),
                                  itemBuilder: (context, index) {
                                    // final message = messages[index];

                                    final chat = _myChats[index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: ListTile(
                                          leading: CachedImage(
                                              imageUrl: chat.imageURL),
                                          title: Text(chat.name ?? ""),
                                          subtitle: Text(
                                              chat.lastMessage?.message ?? ""),
                                          trailing: chat
                                                      .lastMessage?.timestamp !=
                                                  null
                                              ? Text(
                                                  DateFormat("hh:mm a").format(
                                                  (chat.lastMessage!.timestamp!
                                                      .toDate()),
                                                ))
                                              : null,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                        chatUser: chat,
                                                      )),
                                            );
                                          }),
                                    );
                                  });
                            });
                      }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Stream<List<ChatUser>> _buildChatUsers(
    BuildContext context,
    UserModel currentUser,
    List<QueryDocumentSnapshot<Object?>> docs,
  ) async* {
    try {
      List<ChatUser> _myChats = [];

      for (var userDoc in docs) {
        final Map<String, dynamic> _data =
            userDoc.data()! as Map<String, dynamic>;
        UserModel _user = UserModel.fromMap(_data);
        if (currentUser.id != _user.id) {
          List<String> ids = [currentUser.id!, _user.id!];
          ids.sort();

          String chatRoomId = ids.join("_");

          var value = await FirebaseFirestore.instance
              .collection("chat_room")
              .doc(chatRoomId)
              .collection("message")
              .orderBy("timestamp", descending: false)
              .get();

          MessageModel? lastMessage = value.docs.isNotEmpty
              ? MessageModel.fromMap(value.docs.last.data())
              : null;

          _myChats.add(
            ChatUser(
              senderName: context.read<AuthServiceProvider>().displayName,
              name: "${_user.firstName ?? ""} ${_user.lastName ?? ""}",
              imageURL: _user.avatar,
              isRead: true,
              receiverUserId: _user.id,
              receiverUserEmail: _user.email,
              lastMessage: lastMessage,
              fcmToken: _user.fcmToken,
            ),
          );

          yield _myChats;
        }
      }

      // return _myChats;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
