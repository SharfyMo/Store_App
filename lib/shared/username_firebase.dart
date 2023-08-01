import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsernameFromFirestore extends StatefulWidget {
  const UsernameFromFirestore({
    Key? key,
  }) : super(key: key);

  @override
  State<UsernameFromFirestore> createState() => _UsernameFromFirestore();
}

class _UsernameFromFirestore extends State<UsernameFromFirestore> {
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
          return Text(
            "${data['userName']}",
            style: const TextStyle(
              fontSize: 17,
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
