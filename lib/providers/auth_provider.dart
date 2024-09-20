import 'dart:io';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserModel? _user;
  UserModel? get user => _user;
  UserCredential? _userCredential;
  UserCredential? get userCredential => _userCredential;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String get displayName =>
      (_user?.firstName ?? '') + " " + (_user?.lastName ?? '');

  void _setLoader(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final userDoc =
            await _firebaseFirestore.collection('users').doc(user.uid).get();

        print(userDoc);

        if (userDoc.exists) {
          _user = UserModel.fromMap(
            userDoc.data() as Map<String, dynamic>,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      print("failed to fetch user data:$e");
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _setLoader(true);
    try {
      // Register User in Firebase Auth
      _userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? fcmToken = await FireBaseNotifications.getFCMToken();
      print("fcm Token");
      print(fcmToken);
      //add user data in FireStore
      if (_userCredential != null) {
        await _firebaseFirestore
            .collection('users')
            .doc(_userCredential!.user?.uid)
            .set({
          'id': _userCredential!.user?.uid,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'avatar': "",
          'fcmToken': fcmToken ?? "",
          'lastOnline': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print("Failed to add user: $e");
    } finally {
      _setLoader(false);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoader(true);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await fetchUserData();
      updateFcmToken();
    } catch (e) {
      print("Failed to login: $e");
    } finally {
      _setLoader(false);
    }
  }

  Future<String?> _uploadImage(File? file) async {
    try {
      if (file != null) {
        final Reference _storage = FirebaseStorage.instance.ref().child("user_images").child(_user!.id!);
        final snapshot = await _storage.putFile(file);
       final String imageUrl = await snapshot.ref.getDownloadURL();
       return imageUrl;
      } else {
        return null;
      }
    }  catch (e) {
     return null;
    }
  }

  Future<void> updateUser({
    required String firstName,
    required String lastName,
    File? file,
  }) async {
    _setLoader(true);
    try {
      final String? imageUrl = await _uploadImage(file);
      print(imageUrl);
      String? fcmToken= await FireBaseNotifications.getFCMToken();
      if (_user != null) {
        await _firebaseFirestore
            .collection('users')
            .doc(_user?.id)
            .set({
          'id': _user?.id,
          'firstName': firstName,
          'lastName': lastName,
          'email': _user?.email,
          'avatar': imageUrl ?? _user?.avatar,
          'fcmToken': fcmToken ?? _user?.fcmToken,
          'lastOnline': DateTime.now().toIso8601String(),
        });
       await fetchUserData();
      }
    } catch (e) {
      print("Failed to update data: $e");
    } finally {
      _setLoader(false);
    }
  }

  Future<void> signOut() async {
    _setLoader(true);
    try {
      await _firebaseAuth.signOut();
      _userCredential = null;
      _user = null;
      GoogleSignIn().signOut();
    } catch (e) {
      print("Failed to sign out: $e");
    } finally {
      _setLoader(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoader(true);
    try {
      await GoogleSignIn().signOut();
      // authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      String? fcmToken = await FireBaseNotifications.getFCMToken();
      if (googleUser == null) {
        throw Exception("User not found");
      }
      // Obtain the details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) {
        throw Exception("User could not be authenticated");
      }

// Creating new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      _userCredential = await _firebaseAuth.signInWithCredential(credential);

      await _firebaseFirestore
          .collection('users')
          .doc(_userCredential?.user?.uid)
          .set({
        'id': _userCredential?.user?.uid,
        'firstName': googleUser.displayName,
        'lastName': "",
        'email': googleUser.email,
        'avatar': googleUser.photoUrl,
        'fcmToken':fcmToken ?? "",
        'lastOnline': DateTime.now().toIso8601String(),
      });

      print(_userCredential);
    } catch (e) {
      print(e);
      print("EXCEPTION ON GOOGLE SIGN IN");
    } finally {
      _setLoader(false);
    }
  }

  Future<void> resetPassword(
      {required String email, required BuildContext context}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
  Future<void> updateFcmToken()async{
    _setLoader(true);
    try {
      String? fcmToken= await FireBaseNotifications.getFCMToken();
      if (_user != null) {
        await _firebaseFirestore
            .collection('users')
            .doc(_user?.id)
            .set({
          'id': _user?.id,
          'firstName': _user?.firstName,
          'lastName': _user?.lastName,
          'email': _user?.email,
          'avatar':  _user?.avatar,
          'fcmToken': fcmToken ?? _user?.fcmToken,
          'lastOnline': DateTime.now().toIso8601String(),
        });
        await fetchUserData();
      }
    } catch (e) {
      print("Failed to update user data $e");
    } finally {
      _setLoader(false);
    }
  }
}
