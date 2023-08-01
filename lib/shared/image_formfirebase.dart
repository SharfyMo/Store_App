import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImageFromFirestore extends StatefulWidget {
  const ImageFromFirestore({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageFromFirestore> createState() => _ImageFromFirestore();
}

class _ImageFromFirestore extends State<ImageFromFirestore> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userSharfy');
    final credential = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(credential!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return CircleAvatar(
            backgroundColor: const Color.fromARGB(31, 243, 223, 223),
            radius: 60,
            backgroundImage: NetworkImage(data['imglink']),
          );
        }

        return const Text("loading");
      },
    );
  }
}
