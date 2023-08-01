import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sales_project/pages/checkout.dart';
import 'package:sales_project/pages/home.dart';
import 'package:sales_project/pages/profile_page.dart';
import 'package:sales_project/shared/colors.dart';

class Homee extends StatefulWidget {
  const Homee({Key? key}) : super(key: key);

  @override
  _HomeeState createState() => _HomeeState();
}

class _HomeeState extends State<Homee> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: homeColor,
        color: appbarGreen,
        animationDuration: const Duration(milliseconds: 300),
        height: 60,
        items: <Widget>[
          _builNavItem(Icons.person, index == 0),
          _builNavItem(Icons.home, index == 1),
          _builNavItem(Icons.add_shopping_cart, index == 2),
        ],
        index: index,
        onTap: (selctedIndex) {
          setState(() {
            index = selctedIndex;
          });
        },
      ),
      body: Container(
          //  color: Colors.blue,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: getSelectedWidget(index: index)),
    );
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const ProfilePage();
        break;
      case 1:
        widget = const Home();
        break;
      default:
        widget = const Checkot();
        break;
    }
    return widget;
  }

  Widget _builNavItem(IconData icon, bool isSelected) {
    return Icon(
      icon,
      size: 30,
      color: isSelected ? Colors.white : Colors.black,
    );
  }
}
