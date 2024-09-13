import "package:chat_app/providers/auth_provider.dart";
import "package:chat_app/splash_screen.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "notification.dart";
//FUNCTION EXPRESSION
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await FireBaseNotifications().initializeFireBase();// Initialize Firebase
  runApp(const MyFlutterApp());
}

class MyFlutterApp extends StatelessWidget {
  const MyFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => AuthServiceProvider()), // Provide AuthProvider
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Chat App",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
       ),
    );
  }
}
