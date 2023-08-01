// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sales_project/model/item.dart';
import 'package:sales_project/shared/appbar.dart';
import 'package:sales_project/shared/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Detalis extends StatefulWidget {
  // const Detalis({super.key});

  Itemm product;
  Detalis({super.key, required this.product});

  @override
  State<Detalis> createState() => _DetalisState();
}

class _DetalisState extends State<Detalis> {
  bool showdetails = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeColor,
      appBar: AppBar(
        actions: const [proudectandprice()],
        backgroundColor: appbarGreen,
        title: const Text("Details Item"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Image.asset(widget.product.img)),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: bTNgreen,
                ),
                child: Text(
                  "The Price = ${widget.product.salary}",
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 129, 129),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("New"),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 15,
                            color: Color.fromARGB(255, 255, 191, 0),
                          ),
                          Icon(
                            Icons.star,
                            size: 15,
                            color: Color.fromARGB(255, 255, 191, 0),
                          ),
                          Icon(
                            Icons.star,
                            size: 15,
                            color: Color.fromARGB(255, 255, 191, 0),
                          ),
                          Icon(
                            Icons.star,
                            size: 15,
                            color: Color.fromARGB(255, 255, 191, 0),
                          ),
                          Icon(
                            Icons.star,
                            size: 15,
                            color: Color.fromARGB(255, 255, 191, 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse("https://naseeg.online/ar");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_location,
                          size: 26,
                          color: Color.fromARGB(168, 3, 65, 27),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          widget.product.location,
                          style: const TextStyle(fontSize: 19),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  textAlign: TextAlign.start,
                  "Details",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "A Naseeg bag, which is a set of 3 rectangular bags to put clothes or underwear inside and place them inside for private travel, including also using the bag to put and store clothes inside, for long periods.",
                style: const TextStyle(fontSize: 18),
                maxLines: showdetails ? 3 : null,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      showdetails = !showdetails;
                    });
                  },
                  child: Text(showdetails ? "Show More" : "Show Less"))
            ],
          ),
        ),
      ),
    );
  }
}
