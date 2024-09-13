import 'dart:io';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/widgets/auth_text_field.dart';
import 'package:chat_app/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  File? pickedImage;
  ImagePicker imagePicker = ImagePicker();

  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final UserModel? user = context.read<AuthServiceProvider>().user;
    if (user != null) {
      _firstNameController.text = user.firstName ?? "";
      _lastNameController.text = user.lastName ?? " ";
    }
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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.normal,
              fontSize: 26,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(children: [
        Opacity(
          opacity: 0.1,
          child: Image.asset(
            "assets/images/chat_app_image.jpg",
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _showBottomSheet,
                  child: Consumer<AuthServiceProvider>(
                      builder: (_, authProvider, __) {
                    if (pickedImage == null) {
                      return CachedImage(
                        imageUrl: authProvider.user?.avatar ?? "",
                        imageWidth: 100,
                        imageHeight: 100,
                        elevation: 2,
                      );
                    } else {
                      return Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(50),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            pickedImage!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  }),
                ),
                const SizedBox(height: 30,),
                AuthTextField(
                  hintText: "First Name",
                  controller: _firstNameController,
                ),
                const SizedBox(
                  height: 30,
                ),
                AuthTextField(
                  hintText: "Last Name",
                  controller: _lastNameController,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.blue, // Change the background color here
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Consumer<AuthServiceProvider>(
                      builder: (_, authProvider, __) {
                        return authProvider.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                          "Save Profile",
                          style: TextStyle(
                              fontSize: 16, color: Colors.black),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ))
      ]),
    );
  }

  void _showBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: () async {
                // TODO Implement gallery on tap here
                final XFile? xfile =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (xfile != null) {
                  setState(() {
                    pickedImage = File(xfile.path);
                  });
                }
                Navigator.pop(context);
              },
              title: const Text(
                "Gallery",
              ),
            ),
            ListTile(
              onTap: () async {
                // TODO Implement camera on tap here
                final XFile? xfile =
                    await imagePicker.pickImage(source: ImageSource.camera);
                if (xfile != null) {
                  setState(() {
                    pickedImage = File(xfile.path);
                  });
                }
                Navigator.pop(context);
              },
              title: const Text(
                "Camera",
              ),
            ),
          ],
        );
      },
    );
  }
  void _updateProfile() async {
     (await context.read<AuthServiceProvider>().updateUser(
          firstName: _firstNameController.text, lastName: _lastNameController.text,
         file: pickedImage));
        Navigator.pop(
          context,
        );
    }
  }

