import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_project/shared/snackbar.dart';

class GetDataFromFirestore extends StatefulWidget {
  final String documentId;

  const GetDataFromFirestore({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<GetDataFromFirestore> createState() => _GetDataFromFirestoreState();
}

class _GetDataFromFirestoreState extends State<GetDataFromFirestore> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userSharfy');
    final dialogUsernameController = TextEditingController();
    final checkPW = TextEditingController();
    final credential = FirebaseAuth.instance.currentUser;

    myDialog(Map data, dynamic mykey) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            child: Container(
              padding: const EdgeInsets.all(22),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                      controller: dialogUsernameController,
                      maxLength: 20,
                      decoration:
                          InputDecoration(hintText: "  ${data[mykey]}    ")),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            users
                                .doc(credential!.uid)
                                .update({mykey: dialogUsernameController.text});

                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(fontSize: 17),
                          )),
                      TextButton(
                          onPressed: () {
                            // addnewtask();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontSize: 17),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Username : ${data['userName']}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        myDialog(data, 'userName');
                      },
                      icon: const Icon(Icons.edit)),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Age : ${data['Age']} years old",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        myDialog(data, 'Age');
                      },
                      icon: const Icon(Icons.edit)),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Title : ${data['tiltle']} ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        myDialog(data, 'tiltle');
                      },
                      icon: const Icon(Icons.edit)),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11)),
                            child: Container(
                              padding: const EdgeInsets.all(22),
                              height: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextField(
                                      controller: checkPW,
                                      decoration: const InputDecoration(
                                          hintText:
                                              "Please enter the Old password")),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  TextField(
                                      controller: dialogUsernameController,
                                      decoration: const InputDecoration(
                                          hintText:
                                              "Please enter the New password")),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            if (checkPW.text ==
                                                data['password']) {
                                              users
                                                  .doc(credential!.uid)
                                                  .update({
                                                'password':
                                                    dialogUsernameController
                                                        .text
                                              });
                                              credential.updatePassword(
                                                  dialogUsernameController
                                                      .text);
                                              showSnakBar(context,
                                                  "The password has been changed Successfully");
                                            } else {
                                              showSnakBar(context,
                                                  "Please enter the password correctly");
                                            }
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text(
                                            "Edit",
                                            style: TextStyle(fontSize: 17),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            // addnewtask();
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(fontSize: 17),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Change Password",
                      style: TextStyle(fontSize: 17),
                    )),
              ),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                                'Are you sure to delete your account'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text("YES"),
                                onPressed: () {
                                  setState(() {
                                    credential!.delete();
                                    users.doc(credential.uid).delete();
                                    Navigator.pop(context);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: const Text("NO"),
                                onPressed: () {
                                  //Put your code here which you want to execute on No button click.
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Delete Account",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    )),
              ),
            ],
          );
        }

        return const Text("loading");
      },
    );
  }
}
