import 'package:chat_app/email_verification_screen.dart';
import 'package:chat_app/first_screen.dart';
import 'package:chat_app/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'providers/auth_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          context.read<AuthServiceProvider>().fetchUserData();
          if(snapshot.data?.emailVerified ?? false) {
            return FirstScreen();
          } else {
            return EmailVerificationScreen();

          }
        }
        return const LoginScreen();
      },
    );
  }
}
