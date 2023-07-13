import 'package:flutter/material.dart';
import 'package:uniwide/pages/homepage.dart';
import 'package:uniwide/pages/register.dart';
import 'package:uniwide/resources/firebase_methods.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool splash = true;
  bool isLoading = false;
  String errorText = "";

  void signIn() async {
    setState(() {
      isLoading = true;
    });
    String res =
        await FirebaseMethods().emailSignInUser(_email.text, _pass.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const Homepage(),
        ),
      );
    } else {
      setState(() {
        errorText = res;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    splashScreen();
  }

  void splashScreen() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();

    if (await storage.containsKey(key: "loginToken")) {
      String? token = await storage.read(key: "loginToken");
      FirebaseMethods().tokenSignInUser(token!);

      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const Homepage(),
        ),
      );
    } else {
      setState(() {
        splash = !splash;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width,
            height: splash
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height / 2.5,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xfff06000), Color.fromARGB(255, 255, 140, 0)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: splash
                    ? const Radius.circular(0)
                    : const Radius.circular(150),
              ),
            ),
            child: Center(
              child: Image.asset(
                "assets/uniwide_logo.png",
                color: Colors.white,
                height: 100,
                width: 100,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: inputField(Icons.email_rounded, "Email", _email),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: inputField(Icons.key_rounded, "Password", _pass,
                obscureText: true),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  "Forgot Password?",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: GestureDetector(
              onTap: () => signIn(),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xfff06000), Color(0xfff28600)],
                  ),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
              ),
            ),
          ),
          Text(errorText),
          Expanded(
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account ? "),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const Register(),
                    ),
                  );
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                    color: Color(0xfff28600),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Container inputField(
      IconData icon, String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: Colors.grey.shade300,
            blurRadius: 2,
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              obscureText: obscureText,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
