// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_project/pages/forgot_password.dart';
import 'package:sales_project/pages/register.dart';
import 'package:sales_project/pages/verify_email.dart';
import 'package:sales_project/shared/colors.dart';
import 'package:sales_project/shared/contants.dart';
import 'package:sales_project/shared/snackbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Login> {
  bool isloading = false;
  bool isvaild = true;
  final emailAddress = TextEditingController();
  final passwordd = TextEditingController();

  Loginn() async {
    setState(() {
      isloading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text, password: passwordd.text);
      showSnakBar(context, "DONEE...");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const VerifyEmailPage()));
    } on FirebaseAuthException catch (e) {
      showSnakBar(context, "ERROR : ${e.code}");
    }

    setState(() {
      isloading = false;
    });
  }

  @override
  void dispose() {
    emailAddress.dispose();
    passwordd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeColor,
      // backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: const Text("Sign In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                  controller: emailAddress,
                  keyboardType: TextInputType.emailAddress,
                  // obscureText: false,
                  decoration: decorationTextfield.copyWith(
                    hintText: "Enter Is Email",
                    suffixIcon: const Icon(Icons.email),
                  )),
              const SizedBox(
                height: 25,
              ),
              TextField(
                  controller: passwordd,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: isvaild ? true : false,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Is Password",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isvaild = !isvaild;
                            });
                          },
                          icon: isvaild
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)))),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Loginn();
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
                        "Sign in",
                        style: TextStyle(fontSize: 19),
                      ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Forgotpas(),
                        ));
                  },
                  child: const Text(
                    "Forgot Password ?",
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 18),
                  )),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Do not have an account?",
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()));
                      },
                      child: const Text('sign up',
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.underline))),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
