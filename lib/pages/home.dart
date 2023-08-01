// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_project/model/item.dart';
import 'package:sales_project/pages/checkout.dart';
import 'package:sales_project/pages/detalis.dart';
import 'package:sales_project/provider/cart.dart';
import 'package:sales_project/shared/appbar.dart';
import 'package:sales_project/shared/colors.dart';
import 'package:sales_project/pages/profile_page.dart';
import 'package:sales_project/shared/image_formfirebase.dart';
import 'package:sales_project/shared/username_firebase.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final cartInstancee = Provider.of<Cart>(context);
    final userr = FirebaseAuth.instance.currentUser!;

    return Scaffold(
        backgroundColor: homeColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: allitem.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(55),
                      border: Border.all(width: 3, color: Colors.blue)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Detalis(product: allitem[index]),
                          ));
                    },
                    child: GridTile(
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          padding: const EdgeInsets.all(6.5),
                          child: Image.asset(
                            allitem[index].img,
                          )),
                      footer: GridTileBar(
                        trailing: CircleAvatar(
                          backgroundColor: appbarGreen,
                          child: IconButton(
                              onPressed: () {
                                cartInstancee.additem(allitem[index]);
                              },
                              color: Colors.white,
                              icon: Icon(Icons.add)),
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: appbarGreen,
                              border:
                                  Border.all(width: 1, color: Colors.black)),
                          child: Text(
                            "${allitem[index].salary}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(""),
                      ),
                    ),
                  ),
                );
              }),
        ),
        drawer: Drawer(
          backgroundColor: homeColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: UsernameFromFirestore(),
                    accountEmail: Text(userr.email!),
                    currentAccountPicture: ImageFromFirestore(),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/img/egypt2.jpg"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  ListTile(
                      title: Text("Home"),
                      leading: Icon(Icons.home),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      }),
                  ListTile(
                      title: Text("My products"),
                      leading: Icon(Icons.add_shopping_cart),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Checkot()));
                      }),
                  ListTile(
                      title: Text("About"),
                      leading: Icon(Icons.help_center),
                      onTap: () {}),
                  ListTile(
                      title: Text("Profile Page"),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                      }),
                  ListTile(
                      title: Text("Logout"),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                      }),
                ],
              ),
              Container(
                margin: EdgeInsets.all(5),
                child: Text("Developed by Mohamed Abu Hamd © 2023",
                    style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          // ignore: prefer_const_literals_to_create_immutables
          actions: [proudectandprice()],
          backgroundColor: appbarGreen,
          title: Text("Naseeg"),
        ));
  }
}
