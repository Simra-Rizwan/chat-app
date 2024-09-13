import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_profile.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

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
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          centerTitle: true,
          title: const Text(
            "User Profile",
            style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          //   TODO: Add actions here
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditProfile()));
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.red,
                ))
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
            Consumer<AuthServiceProvider>(
              builder: (_, authProvider, __) {
                final user = authProvider.user;
                if (user == null) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedImage(
                            imageUrl: user.avatar ?? "",
                            imageWidth: 100,
                            imageHeight: 100,
                            elevation: 2,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               Text(
                                user.firstName ?? "",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 26,
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              user.lastName ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 26,
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(user.email ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 26,
                              )),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ));
  }
}
