import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/homepage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //rgb(245, 246, 248)
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
      title: "Uniwide Group",
      color: const Color.fromRGBO(245, 246, 248, 1),
      theme: ThemeData(useMaterial3: true),
      home: const Homepage(),
    );
  }
}