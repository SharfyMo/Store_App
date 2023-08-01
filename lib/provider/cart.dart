import 'package:flutter/material.dart';
import 'package:sales_project/model/item.dart';

class Cart with ChangeNotifier {
  List selectitems = [];
  double price = 0;

  additem(Itemm proude) {
    selectitems.add(proude);
    price += proude.salary;

    notifyListeners();
  }

  deleteitem(Itemm proude) {
    selectitems.remove(proude);
    price -= proude.salary;

    notifyListeners();
  }
}
