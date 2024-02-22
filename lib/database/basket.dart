import 'package:etiquette/database/product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductSelection {
  static int nextSelectionId = 0;

  final Product product;
  final int number;
  final bool landscape;
  final int id;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['product'] = product;
    data['landscape'] = landscape;
    data['number'] = number;
    data['object'] = this;
    return data;
  }

  ProductSelection(this.product, this.number, this.id, [this.landscape = true]);
}

class Basket extends ChangeNotifier {
  static final _instance = Basket._privateConstructor();

  static late SharedPreferences _prefs;

  Basket._privateConstructor();

  factory Basket() {
    return _instance;
  }

  Future<void> initialize(List<Product> products) async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? items = _prefs.getStringList('items');
    if (items == null) return;
    for (var element in items) {
      List<String> data = element.toString().split(';');
      try {
        Product product =
            products.firstWhere((e) => e.id.toString() == data[0]);
        bool landscape = int.parse(data[2]) == 1 ? true : false;
        int selectedId = int.parse(data[3]);
        if (selectedId >= ProductSelection.nextSelectionId) {
          ProductSelection.nextSelectionId = selectedId + 1;
        }
        var selection =
            ProductSelection(product, int.parse(data[1]), selectedId, landscape);
        productSelections.add(selection);
        // ignore: empty_catches
      } catch (e) {}
    }
    notifyListeners();
  }

  Future<void> updateSharedPreference() async {
    List<String> items = [];

    for (var element in productSelections) {
      items.add(
          "${element.product.id};${element.number};${element.landscape ? '1' : '0'};${element.id}");
    }
    if (items.isEmpty) ProductSelection.nextSelectionId = 0;
    await _prefs.setStringList('items', items);
    notifyListeners();
  }

  List<ProductSelection> productSelections = [];
}
