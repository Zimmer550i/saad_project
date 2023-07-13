import 'package:flutter/material.dart';
import 'package:uniwide/models/app_user.dart';
import 'package:uniwide/resources/firebase_methods.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNum = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool obscurePass = true;
  String err = "";
  bool isLoading = false;
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Text(
                "Please enter the details below",
                style: TextStyle(color: Colors.grey.shade700),
              ),
              inputField("First Name", Icons.person, firstName),
              inputField("First Name", Icons.person, lastName),
              inputField("Email", Icons.email_rounded, email),
              inputField("Phone Number", Icons.phone_android_rounded, phoneNum,
                  type: TextInputType.phone),
              inputField("Password", Icons.key_rounded, password,
                  isPassword: true),
              inputField("Confirm Password", Icons.key_rounded, confirmPassword,
                  isPassword: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    shape: const CircleBorder(),
                    checkColor: Colors.white,
                    value: checked,
                    onChanged: (value) {
                      setState(() {
                        checked = value!;
                      });
                    },
                  ),
                  const Text("I accept the "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const Register(),
                        ),
                      );
                    },
                    child: const Text(
                      "Terms & Condition",
                      style: TextStyle(
                        color: Color(0xfff28600),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: GestureDetector(
                  onTap: () => registerNewUser(),
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
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ),
                ),
              ),
              Text(
                err,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account ? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color(0xfff28600),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputField(
      String name, IconData icon, TextEditingController controller,
      {bool isPassword = false, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                            isDense: true, border: InputBorder.none),
                        obscureText: isPassword ? obscurePass: false,
                        keyboardType: type,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          obscurePass = !obscurePass;
                        });
                      },
                      child: Icon(
                        icon,
                        color: const Color(0xfff06000),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 25,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              color: Colors.white,
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void registerNewUser() async {
    setState(() {
      isLoading = true;
    });

    String? userID =
        await FirebaseMethods().emailSignUpUser(email.text, password.text);

    if (userID == null) {
      SnackBar temp = const SnackBar(content: Text("Some error occured!"));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(temp);

      setState(() {
        isLoading = false;
      });

      return;
    }

    AppUser user = AppUser(
      userID: userID,
      mobileNumber: phoneNum.text,
      email: email.text,
      firstName: firstName.text,
      lastName: lastName.text,
      imgUrl: "",
    );

    String res = await FirebaseMethods().createUser(user);
    SnackBar temp = SnackBar(
      content: Text(res),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(temp);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}
