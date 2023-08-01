import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_project/pages/login.dart';
import 'package:sales_project/shared/colors.dart';
import 'package:sales_project/shared/contants.dart';
import 'package:sales_project/shared/snackbar.dart';

class Forgotpas extends StatefulWidget {
  const Forgotpas({super.key});

  @override
  State<Forgotpas> createState() => _ForgotpasState();
}

class _ForgotpasState extends State<Forgotpas> {
  final emailController = TextEditingController();
  bool isloading = false;
  final formkey = GlobalKey<FormState>();

  resetpassword() async {
    isloading = true;

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      if (!mounted) return;
      showSnakBar(context, "Done - please check ur Email");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    } on FirebaseAuthException catch (e) {
      showSnakBar(context, "ERROO.. ${e.code}");
    }

    isloading = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeColor,
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: const Text("Reset Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(33),
        child: Center(
          child: Form(
            key: formkey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Enter your Email To Rest your Password"),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                  validator: (value) {
                    return value!.contains(RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                        ? null
                        : "Enter a valid email";
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Is Email",
                      suffixIcon: const Icon(Icons.email))),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formkey.currentState!.validate()) {
                    resetpassword();
                  } else {
                    showSnakBar(context, "ERROR..Enter your Email");
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(bTNgreen),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                ),
                child: isloading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Reset Password",
                        style: TextStyle(fontSize: 19),
                      ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
