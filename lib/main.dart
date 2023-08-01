import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_project/pages/login.dart';
import 'package:sales_project/pages/verify_email.dart';
import 'package:sales_project/provider/cart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sales_project/shared/snackbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return Cart();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.hasError) {
              return showSnakBar(context, "Something went wrong");
            } else if (snapshot.hasData) {
              return const VerifyEmailPage();
            } else {
              return const Login();
            }
          },
        ),
      ),
    );
  }
}
