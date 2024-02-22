import 'dart:io';

import 'package:etiquette/database/basket.dart';
import 'package:etiquette/database/database_controller.dart';
import 'package:etiquette/database/preferences.dart';
import 'package:etiquette/database/product.dart';
import 'package:etiquette/database/product_fields.dart';
import 'package:etiquette/database_view/body_datatable/body.dart';
import 'package:etiquette/database_view/filter/datatable_filter.dart';
import 'package:etiquette/printer/printer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../database/etiquette.dart';
import '../database/filter.dart';
import '../report.dart';
import '../selection/selection.dart';
import 'body_csv/view.dart';
import 'body_datatable/datatable.dart';
import 'body_datatable/datatable_search.dart';
import 'body_datatable/loading.dart';
import 'body_datatable/overlay.dart';
import 'drawer/view.dart';
import 'shortcut_controller.dart';

class DatabaseView extends StatefulWidget {
  const DatabaseView({super.key});

  @override
  State<StatefulWidget> createState() => DatabaseViewState();
}

class DatabaseViewState extends State<DatabaseView> {
  bool wantReimport = false;
  GlobalKey<ProductOverlayState> overlayKey = GlobalKey<ProductOverlayState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ProductDatatableState> dataTableKey =
      GlobalKey<ProductDatatableState>();

  void closeReimportView() {
    setState(() => wantReimport = false);
  }

  double? loadingPercents;
  double? loadingPercents2;
  String message = "";

  Future<void> selectFile([bool test = false]) async {
    FilePicker filePicker = FilePicker.platform;
    String? fileData;
    var messenger = ScaffoldMessenger.of(context);
    FilePickerResult? result;
    result = await filePicker
        .pickFiles(allowedExtensions: ['csv'], lockParentWindow: true);

    if (result != null) {
      if (result.files.single.extension != "csv") {
        SnackBar snackBar =
            const SnackBar(content: Text('doit etre un fichier csv'));
        messenger.showSnackBar(snackBar);
        return;
      }

      File file = File(result.files.single.path!);
      Stream<List<int>> data = file.openRead();
      await data.forEach((element) {
        fileData = "$fileData${String.fromCharCodes(element)}";
      });
      onImportCSV(fileData, test);
    } else {
      // User canceled the picker
    }
  }

  Future<void> onImportCSV(String? fileData, [bool test = false]) async {
    Report.messages.clear();
    if (!test) {
      message = "";
      closeReimportView();
      message = "reinitialisation de la base de données";
      await baseDatabaseController.droppingDatabase();
      productController?.products.clear();
      productController?.db = await baseDatabaseController.database;
      setState(() {});
      message = "nettoyage des filtres";
      await Filter().clearFilter();
    }
    if (fileData != null) {
      message = "calcul du nombres d'élements a importer";
      List<String> datas = fileData.split('\n');
      datas.removeAt(0);
      datas.removeWhere((e) => e.trim().isEmpty);
      int len = datas.length + 1;
      message = "importations : 0 / $len";
      int i = 0;
      loadingPercents = 0;
      loadingPercents2 = 0;
      for (var csvLine in datas) {
        i++;
        loadingPercents = i / len;
        message = "importations : $i / $len";
        Product product;
        try {
          product = Product.fromCSVLine(csvLine);
        } on Exception catch (e) {
          String eString = e.toString();
          eString = eString.replaceAll("Exception: ", "");
          Report.messages.add("Ligne $i\$$eString");
          setState(() {});
          continue;
        }
        if (!test) {
          Filter().populateFromProduct(product);
          productController?.speedInsert(product);
          setState(() {});
        }
      }
      if (test) {
        loadingPercents = null;
        loadingPercents2 = null;
        SnackBar snackBar;
        if (Report.messages.isNotEmpty) {
          snackBar = const SnackBar(
              content: Text("Le test a révéler des erreurs dans le fichier"));
        } else {
          snackBar = const SnackBar(
              content: Text("Aucun probleme détecté lors du test"));
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
        return;
      }
      i = 0;
      Stream<void> s = productController!.batchInsertAllDatabase();
      s.listen((event) {
        i++;
        message = "sauvegarde : $i / $len";
        loadingPercents2 = i / len;
        setState(() {});
      }, onDone: () async {
        message = "creations des listes pour les filtres";
        await Filter().saveFilter();
        message = ("importations terminer");
        loadingPercents = null;
        loadingPercents2 = null;
        setState(() {});
      });
    }
  }

  ProductController? productController;
  BaseDatabaseController baseDatabaseController = BaseDatabaseController();
  TextEditingController searchController = TextEditingController();

  void forceUpdate() {
    if (mounted) setState(() {});
  }

  Future<void> populateData() async {
    await Future.delayed(const Duration(seconds: 1));
    var db = await baseDatabaseController.database;
    ProductController localProductController = ProductController(db);
    Preferences().etiquetteController = EtiquetteController(db);
    if (BaseDatabaseController.mustBeInitialize) {
      BaseDatabaseController.mustBeInitialize = false;
      await Preferences().clearSharedPreferences();
      await Preferences().etiquetteController!.insert(InitialValue.defaultEtiquette);
    }
    var products = await localProductController.gets();
    await Basket().initialize(products);
    await Filter().reloadFilterFromSharedPreferences();
    await Preferences().init();
    await PrinterTicker().initialize();
    productController = localProductController;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    Preferences().addListener(forceUpdate);
    populateData();
  }

  @override
  void dispose(){
    Preferences().removeListener(forceUpdate);
    super.dispose();
  }

  Product? hoverProduct;
  Product? selectedProduct;

  void onHoverProduct(Product? product) =>
      setState(() => hoverProduct = product);

  void onSelectProduct(Product product) {
    if (overlayKey.currentState?.mouseX == 0.0) return;
    searchFocusNode.unfocus();
    overlayKey.currentState?.lockOverlay = true;
    setState(() {
      selectedProduct = product;
    });
  }

  void onUnSelectProduct() {
    if (selectedProduct == null) return;
    overlayKey.currentState?.lockOverlay = false;
    overlayKey.currentState?.numberController.clear();
    overlayKey.currentState?.mouseX = 0;
    overlayKey.currentState?.mouseY = 0;
    setState(() => selectedProduct = null);
    searchFocusNode.requestFocus();
  }

  void onAddedProduct(Product product, int number) {
    setState(() {
      Basket().productSelections.add(ProductSelection(product, number, ProductSelection.nextSelectionId++));
      Basket().updateSharedPreference();
    });
    onUnSelectProduct();
    searchFocusNode.requestFocus();
  }

  FocusNode searchFocusNode = FocusNode();

  void onWantSortProduct(String field, bool reverse) {
    List<Product> products = productController!.products;
    int Function(Product, Product)? compare;
    switch (field) {
      case (ProductField.lieu):
        compare = (a, b) =>
            reverse ? b.lieu.compareTo(a.lieu) : a.lieu.compareTo(b.lieu);
        break;
      case (ProductField.modalite):
        compare = (a, b) => reverse
            ? b.modality.compareTo(a.modality)
            : a.modality.compareTo(b.modality);
        break;
      case (ProductField.dotation):
        compare = (a, b) => reverse
            ? b.dotation.compareTo(a.dotation)
            : a.dotation.compareTo(b.dotation);
        break;
      case (ProductField.toxicite):
        compare = (a, b) => reverse
            ? b.toxicity.compareTo(a.toxicity)
            : a.toxicity.compareTo(b.toxicity);
        break;
      case (ProductField.famille):
        compare = (a, b) => reverse
            ? b.family.compareTo(a.family)
            : a.family.compareTo(b.family);
        break;
      case (ProductField.sousFamille):
        compare = (a, b) => reverse
            ? b.subFamily.compareTo(a.subFamily)
            : a.subFamily.compareTo(b.subFamily);
        break;
      default:
    }
    if (compare == null) return;
    products.sort(compare);
    dataTableKey.currentState!.update();
  }

  void onChangeFilter(String field) {
    Filter().filter(productController!.products);
    dataTableKey.currentState!.update();
  }

  var globalFocusNode = FocusNode();

  bool multipleSelection = true;

  List<Product> selectedProducts = [];
  ValueNotifier<bool> updateSelectButton = ValueNotifier(false);

  void addSelection() {
    overlayKey.currentState?.mouseX = 0;
    SelectionProducts.show(context, selectedProducts).then((value) {
      if (value == true) {
        selectedProducts.clear();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (productController == null) return const LoadingDataTable();
    if (wantReimport) return ImportCsvFile(onValidateImportation: onImportCSV);
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notif) {
        overlayKey.currentState?.mouseX = 0;
        overlayKey.currentState?.mouseY = 0;
        return false;
      },
      child: GestureDetector(
        onTap: () => globalFocusNode.requestFocus(),
        child: Focus(
            focusNode: globalFocusNode,
            autofocus: true,
            onKey: onKeyEvent,
            child: Stack(
              children: [
                Scaffold(
                    key: scaffoldKey,
                    backgroundColor: Colors.transparent,
                    endDrawer: const Drawer(child: ImpressionView()),
                    body: DatabaseViewBody(children: [
                      Visibility(
                        visible: loadingPercents != null,
                        child: Tooltip(
                          message: message,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0, top: 4.0),
                            child: LinearProgressIndicator(
                              value: ((loadingPercents ?? 0) * 0.5) +
                                  ((loadingPercents2 ?? 0) * 0.5),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      DatatableSearch(
                          searchFocusNode: searchFocusNode,
                          searchController: searchController,
                          onChanged: () => setState(() {}),
                          lockImportButton: loadingPercents != null,
                          productController: productController),
                      Row(
                        children: [
                          ValueListenableBuilder(
                            builder: (context, _, __) {
                              return Visibility(
                                maintainAnimation: true,
                                maintainSize: true,
                                maintainState: true,
                                visible: selectedProducts.isNotEmpty,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8.0),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    onPressed: () => addSelection(),
                                    color: Colors.green,
                                    child: const Text("Ajouter la selection"),
                                  ),
                                ),
                              );
                            },
                            valueListenable: updateSelectButton,
                          ),
                          Expanded(
                            child: Align(
                              child: DataTableFilter(
                                  onWantSort: onWantSortProduct,
                                  onChangeFilter: onChangeFilter),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                          child: ProductDatatable(
                              key: dataTableKey,
                              productController: productController!,
                              searchController: searchController,
                              onHoverProduct: onHoverProduct,
                              onSelectProduct: onSelectProduct,
                              selectedProducts: selectedProducts,
                              updateSelectButton: updateSelectButton)),
                    ])),
                Visibility(
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  visible: Preferences().showOverlay,
                  child: ProductOverlay(
                      product: hoverProduct ?? selectedProduct,
                      key: overlayKey,
                      onAddedProduct: onAddedProduct,
                      onUnSelectProduct: onUnSelectProduct,
                      selected: selectedProduct != null),
                ),
              ],
            )),
      ),
    );
  }
}
