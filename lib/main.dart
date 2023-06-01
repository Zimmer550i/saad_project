import 'package:flutter/material.dart';
import 'pages/homepage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //rgb(245, 246, 248)
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Uniwide Group",
      color: Color.fromRGBO(245, 246, 248, 1),
      home: Homepage(),
    );
  }
}