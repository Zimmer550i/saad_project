import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uniwide/utils.dart/check_token.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkToken() async {
    return await const FlutterSecureStorage().containsKey(key: "loginToken");
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    Future<bool> tokenExists = checkToken();

    return MaterialApp(
      title: "Uniwide Group",
      color: Colors.grey[300],
      theme: ThemeData(useMaterial3: true, fontFamily: "Geologica"),
      home: AnimatedSplashScreen(
        duration: 1000,
        animationDuration: const Duration(milliseconds: 500),
        splash: "assets/uniwide_logo.png",
        splashIconSize: 200,
        nextScreen: CheckToken(tokenExists: tokenExists,),
      ),
    );
  }
}
