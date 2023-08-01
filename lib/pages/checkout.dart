// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_project/provider/cart.dart';
import 'package:sales_project/shared/appbar.dart';
import 'package:sales_project/shared/colors.dart';

class Checkot extends StatelessWidget {
  const Checkot({super.key});

  @override
  Widget build(BuildContext context) {
    final cartInstancee = Provider.of<Cart>(context);
    return Scaffold(
        backgroundColor: homeColor,
        appBar: AppBar(
          backgroundColor: appbarGreen,
          actions: [const proudectandprice()],
          title: const Text("Check Out"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .6,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: cartInstancee.selectitems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: const Text("Naseeg"),
                            subtitle: Text(
                                "${cartInstancee.selectitems[index].salary}"),
                            leading: CircleAvatar(
                                child: Image.asset(
                              cartInstancee.selectitems[index].img,
                              fit: BoxFit.cover,
                            )),
                            trailing: IconButton(
                                onPressed: () {
                                  cartInstancee.deleteitem(
                                      cartInstancee.selectitems[index]);
                                },
                                icon: const Icon(Icons.remove)),
                          ),
                        );
                      }),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Total Price : ${cartInstancee.price}",
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(bTNpink),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)))),
              ),
            ],
          ),
        ));
  }
}
