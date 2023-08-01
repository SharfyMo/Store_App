// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_project/pages/checkout.dart';
import 'package:sales_project/provider/cart.dart';

class proudectandprice extends StatelessWidget {
  const proudectandprice({super.key});

  @override
  Widget build(BuildContext context) {
    final cartInstancee = Provider.of<Cart>(context);
    return Row(
      children: [
        Stack(
          children: [
            Positioned(
              bottom: 24,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(211, 164, 255, 193),
                      shape: BoxShape.circle),
                  child: Text(
                    "${cartInstancee.selectitems.length}",
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                  )),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Checkot(),
                    ));
              },
              icon: const Icon(Icons.add_shopping_cart),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            "\$ ${cartInstancee.price}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
