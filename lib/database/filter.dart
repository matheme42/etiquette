import 'package:etiquette/database/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'product_fields.dart';

class Filter extends ChangeNotifier {
  static final Filter _instance = Filter.privateConstructor();

  Filter.privateConstructor();

  factory Filter() {
    return _instance;
  }

  List<String> lieu = [];

  List<String> modality = [];

  List<String> dotation = [];

  List<String> toxicity = [];

  List<String> family = [];

  List<String> subfamily = [];

  List<String> flags = [
    ProductField.abriLumiere,
    ProductField.frigo,
    ProductField.medicamentARisque
  ];

  /// //////////////////////////////////////////

  List<String> selectedLieu = [];

  List<String> selectedModality = [];

  List<String> selectedDotation = [];

  List<String> selectedToxicity = [];

  List<String> selectedFamily = [];

  List<String> selectedSubfamily = [];

  List<String> selectedFlag = [];

  List<Product> filteredProduct = [];

  /// //////////////////////////////////////////

  List<String> searchBarAffinity = [];

  Future<void> updateSharedPreferenceSearchBarAffinity() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList("search", searchBarAffinity);
    notifyListeners();
  }

  filter(List<Product> products) {
    if (selectedLieu.isNotEmpty) {
      products = products
          .where((e) => selectedLieu.contains(e.lieu.toLowerCase()))
          .toList();
    }
    if (selectedModality.isNotEmpty) {
      products = products
          .where((e) => selectedModality.contains(e.modality.toLowerCase()))
          .toList();
    }
    if (selectedDotation.isNotEmpty) {
      products = products
          .where((e) => selectedDotation.contains(e.dotation.toLowerCase()))
          .toList();
    }
    if (selectedToxicity.isNotEmpty) {
      products = products
          .where((e) => selectedToxicity.contains(e.toxicity.toString()))
          .toList();
    }
    if (selectedFamily.isNotEmpty) {
      products = products
          .where((e) => selectedFamily.contains(e.family.toLowerCase()))
          .toList();
    }
    if (selectedSubfamily.isNotEmpty) {
      products = products
          .where((e) => selectedSubfamily.contains(e.subFamily.toLowerCase()))
          .toList();
    }
    if (selectedFlag.isNotEmpty) {
      if (selectedFlag.contains(ProductField.abriLumiere)) {
        products = products.where((e) => e.abriLumiere).toList();
      }
      if (selectedFlag.contains(ProductField.frigo)) {
        products = products.where((e) => e.fridge).toList();
      }
      if (selectedFlag.contains(ProductField.medicamentARisque)) {
        products = products.where((e) => e.risque).toList();
      }
    }
    filteredProduct = products;
  }

  Future<void> reloadFilterFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lieu = preferences.getStringList(ProductField.lieu) ?? [];
    modality = preferences.getStringList(ProductField.modalite) ?? [];
    dotation = preferences.getStringList(ProductField.dotation) ?? [];
    toxicity = preferences.getStringList(ProductField.toxicite) ?? [];
    family = preferences.getStringList(ProductField.famille) ?? [];
    subfamily = preferences.getStringList(ProductField.sousFamille) ?? [];

    searchBarAffinity = preferences.getStringList("search") ??
        [
          ProductField.libelle1,
          ProductField.libelle2,
          ProductField.famille,
          ProductField.sousFamille,
          ProductField.lieu,
          ProductField.codeMedial,
          ProductField.codeBarre,
        ];
  }

  Future<void> clearFilter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    lieu.clear();
    modality.clear();
    dotation.clear();
    toxicity.clear();
    family.clear();
    subfamily.clear();

    selectedSubfamily.clear();
    selectedFamily.clear();
    selectedModality.clear();
    selectedToxicity.clear();
    selectedDotation.clear();
    selectedLieu.clear();
    selectedFlag.clear();
    await preferences.setStringList(ProductField.lieu, []);
    await preferences.setStringList(ProductField.modalite, []);
    await preferences.setStringList(ProductField.dotation, []);
    await preferences.setStringList(ProductField.toxicite, []);
    await preferences.setStringList(ProductField.famille, []);
    await preferences.setStringList(ProductField.sousFamille, []);
  }

  Future<void> saveFilter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(ProductField.lieu, lieu);
    await preferences.setStringList(ProductField.modalite, modality);
    await preferences.setStringList(ProductField.dotation, dotation);
    await preferences.setStringList(ProductField.toxicite, toxicity);
    await preferences.setStringList(ProductField.famille, family);
    await preferences.setStringList(ProductField.sousFamille, subfamily);
  }

  void populateFromProduct(Product product) {
    if (!lieu.contains(product.softLieu)) lieu.add(product.softLieu);
    if (!modality.contains(product.softModality)) modality.add(product.softModality);
    if (!dotation.contains(product.softDotation)) dotation.add(product.softDotation);
    if (!toxicity.contains(product.toxicity.toString())) toxicity.add(product.toxicity.toString());
    if (!family.contains(product.softFamily)) family.add(product.softFamily);
    if (!subfamily.contains(product.softSubFamily)) subfamily.add(product.softSubFamily);
  }
}
