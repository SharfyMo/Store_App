// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_project/pages/login.dart';
import 'package:sales_project/shared/colors.dart';
import 'package:sales_project/shared/contants.dart';
import 'package:sales_project/shared/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' show basename;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  bool isvaild = true;
  bool isloading = false;
  File? imgPath;
  String? imgName;

  CollectionReference users =
      FirebaseFirestore.instance.collection('userSharfy');

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final titleController = TextEditingController();
  final ageController = TextEditingController();
  final usernameController = TextEditingController();

  bool hasMin8Characters = false;

  Min8Characters(String password) {
    hasMin8Characters = false;
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        hasMin8Characters = true;
      }
    });
  }

  bool hasDigits = false;

  Digits(String password) {
    hasDigits = false;
    setState(() {
      if (password.contains(RegExp(r'[0-9]'))) {
        hasDigits = true;
      }
    });
  }

  bool hasLowercase = false;

  Lowercase(String password) {
    hasLowercase = false;
    setState(() {
      if (password.contains(RegExp(r'[a-z]'))) {
        hasLowercase = true;
      }
    });
  }

  bool hasUppercase = false;

  Uppercase(String password) {
    hasUppercase = false;
    setState(() {
      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }
    });
  }

  bool hasSpecialCharacters = false;

  SpecialCharacters(String password) {
    hasSpecialCharacters = false;
    setState(() {
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacters = true;
      }
    });
  }

  register() async {
    try {
      setState(() {
        isloading = true;
      });

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref(imgName);
      await storageRef.putFile(imgPath!);

      // Get img url
      String url = await storageRef.getDownloadURL();

      users
          .doc(credential.user!.uid)
          .set({
            'imglink': url,
            'userName': usernameController.text,
            'Age': ageController.text,
            'tiltle': titleController.text,
            'email': emailController.text,
            'password': passwordController.text
          })
          .then((value) => showSnakBar(context, "User Added"))
          .catchError(
              (error) => showSnakBar(context, "Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        showSnakBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        showSnakBar(context, 'The account already exists for that email.');
      } else {
        showSnakBar(context, "ERROR - please try again later");
      }
    } catch (e) {
      showSnakBar(context, e.toString());
    }

    setState(() {
      isloading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  uploadImage() async {
    final pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        showSnakBar(context, "NO img selected");
      }
    } catch (e) {
      showSnakBar(context, "Error => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeColor,
      //  backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: appbarGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        imgPath == null
                            ? const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(31, 243, 223, 223),
                                radius: 60,
                                backgroundImage:
                                    AssetImage("assets/img/avatar.png"),
                              )
                            : ClipOval(
                                child: Image.file(
                                  imgPath!,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Positioned(
                            bottom: -10,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                uploadImage();
                              },
                              icon: const Icon(Icons.add_a_photo),
                              color: const Color.fromARGB(122, 44, 185, 15),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Is UserName",
                            suffixIcon: const Icon(Icons.person))),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter your Age :",
                            suffixIcon: const Icon(Icons.person))),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter your Title :",
                            suffixIcon: const Icon(Icons.person_outline))),
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
                    TextFormField(
                        onChanged: (value) {
                          Min8Characters(value);
                          Digits(value);
                          Lowercase(value);
                          Uppercase(value);
                          SpecialCharacters(value);
                        },
                        validator: (value) {
                          return value!.length < 8
                              ? "Enter at least 8 characters"
                              : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
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
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                hasMin8Characters ? Colors.green : Colors.white,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("At least 8 characters"),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasDigits ? Colors.green : Colors.white),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("At least 1 numbe"),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  hasUppercase ? Colors.green : Colors.white),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Has Uppercase"),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  hasLowercase ? Colors.green : Colors.white),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Has  Lowercase "),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasSpecialCharacters
                                  ? Colors.green
                                  : Colors.white),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Has  Special Characters "),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate() &&
                            imgName != null &&
                            imgPath != null) {
                          await register();
                          if (!mounted) return;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        } else {
                          showSnakBar(context, "ERROR");
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(bTNgreen),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                      child: isloading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Register",
                              style: TextStyle(fontSize: 19),
                            ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Do you Sing Now",
                            style: TextStyle(fontSize: 18)),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            },
                            child: const Text('sign IN',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18))),
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
