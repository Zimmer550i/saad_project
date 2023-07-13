import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uniwide/pages/login.dart';
import 'package:uniwide/pages/register.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //rgb(245, 246, 248)
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
      title: "uniwide Group",
      // color: const Color.fromRGBO(245, 246, 248, 1),
      color: Colors.grey[300],
      theme: ThemeData(useMaterial3: true, fontFamily: "Geologica"),
      home: const Login(),
    );
  }
}
