import "dart:async";
import "package:chat_app/auth_gate.dart";
import "package:flutter/material.dart";

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState() {
    super.initState();
    // Navigate to FirstScreen after a 3-second delay
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
        MaterialPageRoute(
          builder: (context) => const AuthGate(),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/chat_app_splash.png",
          height: 200,
          width: 700,
        ),
      ),
    );
  }
  }