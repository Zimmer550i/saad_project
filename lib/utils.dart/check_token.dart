import 'package:flutter/material.dart';
import 'package:uniwide/pages/homepage.dart';
import 'package:uniwide/pages/login.dart';

class CheckToken extends StatelessWidget {
  final Future<bool> tokenExists;
  const CheckToken({super.key, required this.tokenExists});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: tokenExists,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          bool hasToken = snapshot.data ?? false;
          if (hasToken) {
            return const Homepage();
          } else {
            return const Login();
          }
      },
    );
  }
}
