// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_project/shared/colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sales_project/shared/data_from_firestore.dart';
import 'dart:io';
import 'package:path/path.dart' show basename;
import 'package:sales_project/shared/image_formfirebase.dart';
import 'package:sales_project/shared/snackbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users =
      FirebaseFirestore.instance.collection('userSharfy');

  String? imgName;

  File? imgPath;
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
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pop(context);
            },
            label: const Text(
              "logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: appbarGreen,
        title: const Text("Profile Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    imgPath == null
                        ? const ImageFromFirestore()
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
                          onPressed: () async {
                            await uploadImage();
                            if (imgPath != null) {
                              // Upload image to firebase storage
                              final storageRef =
                                  FirebaseStorage.instance.ref(imgName);
                              await storageRef.putFile(imgPath!);

// Get img url
                              String url = await storageRef.getDownloadURL();

// Store img url in firestore[database]
                              users.doc(credential!.uid).update({
                                "imgURL": url,
                              });
                            }
                          },
                          icon: const Icon(Icons.add_a_photo),
                          color: const Color.fromARGB(122, 44, 185, 15),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      "Email:   ${credential!.email}    ",
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      "Created date : ${DateFormat("MMM d, y").format(credential!.metadata.creationTime!)}   ",
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      "Last Signed In : ${DateFormat("MMM d, y").format(credential!.metadata.lastSignInTime!)}  ",
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 131, 177, 255),
                    borderRadius: BorderRadius.circular(11)),
                child: const Text(
                  "Your Personal Information",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )),
              GetDataFromFirestore(documentId: credential!.uid),
            ],
          ),
        ),
      ),
    );
  }
}
