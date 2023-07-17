import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uniwide/pages/homepage.dart';
import 'package:uniwide/pages/login.dart';

class CheckToken extends StatelessWidget {
  const CheckToken({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkToken(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          bool hasToken = snapshot.data ?? false;
          if (hasToken) {
            return const Homepage();
          } else {
            return const Login();
          }
        }
      },
    );
  }

  Future<bool> checkToken() async {
    return await const FlutterSecureStorage().containsKey(key: "loginToken");
  }
}
