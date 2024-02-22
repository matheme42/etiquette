import 'package:etiquette/extensions.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_controller.dart';

class Product extends Model {
  static const String tableName = "Product";


  /// 1er nom possible pour le produit
  late String _libelle1;
  late String softLibelle1;
  String get libelle1 => _libelle1;
  set libelle1(String value) {
    _libelle1 = value;
    softLibelle1 = value.toLowerCase().replaceAllDiacritics();
  }


  /// 2eme nom possible pour le produit
  late String _libelle2;
  late String softLibelle2;
  String get libelle2 => _libelle2;
  set libelle2(String value) {
    _libelle2 = value;
    softLibelle2 = value.toLowerCase().replaceAllDiacritics();
  }

  /// famille du produit
  late String _family;
  late String softFamily;
  String get family => _family;
  set family(String value) {
    _family = value;
    softFamily = value.toLowerCase().replaceAllDiacritics();
  }

  /// sous famille du produit
  late String _subFamily;
  late String softSubFamily;
  String get subFamily => _subFamily;
  set subFamily(String value) {
    _subFamily = value;
    softSubFamily = value.toLowerCase().replaceAllDiacritics();
  }

  /// code produit
  late String codeMedial;


  /// quantité inscrite sur l'etiquette
  late int quantity;

  /// lieu
  late String _lieu;
  late String softLieu;
  String get lieu => _lieu;
  set lieu(String value) {
    _lieu = value;
    softLieu = value.toLowerCase().replaceAllDiacritics();
  }

  /// modality dtp / udm
  late String _modality;
  late String softModality;
  String get modality => _modality;
  set modality(String value) {
    _modality = value;
    softModality = value.toLowerCase().replaceAllDiacritics();
  }

  /// emplacement associer du produit
  /// Frigo / Armoire / consommables / Chariot urgence
  late String _dotation;
  late String softDotation;
  String get dotation => _dotation;
  set dotation(String value) {
    _dotation = value;
    softDotation = value.toLowerCase().replaceAllDiacritics();
  }

  /// level of toxicity
  late int toxicity;

  /// the data of the barcode
  late String barCode;

  /// by default set to false
  bool abriLumiere = false;

  /// by default set to false
  bool fridge = false;

  /// by default set to false
  bool risque = false;

  Product.fromMap(Map<String, dynamic> data) {
    fromMap(data);
  }

  Product.fromCSVLine(String csvLine) {
    List<String> data = csvLine.split(';');
    if (data.length != 14) {
      throw Exception("La ligne ne contient pas le bon nombres d'elements\n"
          "lu: ${data.length} attendu: 14\n");
    }
    List<String> exceptions = [];
    libelle1 = data[0].toString().trim();
    libelle2 = data[1].toString().trim();
    family = data[2].toString().trim();
    subFamily = data[3].toString().trim();
    codeMedial = data[4].toString().trim();
    int? parsedQuantity = int.tryParse(data[5].toString());
    if (parsedQuantity == null) exceptions.add("Quantité incorrect");
    quantity = parsedQuantity ?? 0;
    lieu = data[6].toString().trim();
    modality = data[7].toString().trim();
    dotation = data[8].toString().trim();
    int? parsedToxicity = int.tryParse(data[9].toString());
    if (parsedToxicity == null) exceptions.add("Toxicité incorrect");
    toxicity = parsedToxicity ?? 0;
    barCode = data[10].toString().trim();
    abriLumiere = RegExp(r'^[oy]').hasMatch(data[11].toString().toLowerCase())
        ? true
        : false;
    fridge = RegExp(r'^[oy]').hasMatch(data[12].toString().toLowerCase())
        ? true
        : false;
    risque = RegExp(r'^[oy]').hasMatch(data[13].toString().toLowerCase())
        ? true
        : false;
    if (exceptions.isNotEmpty) throw Exception("${exceptions.join("\n")}\n");
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> data = {};
    data['libelle1'] = libelle1;
    data['libelle2'] = libelle2;
    data['family'] = family;
    data['subfamily'] = subFamily;
    data['medial'] = codeMedial;
    data['quantity'] = quantity;
    data['lieu'] = lieu;
    data['modality'] = modality;
    data['dotation'] = dotation;
    data['toxicity'] = toxicity;
    data['barcode'] = barCode;
    data['abri'] = abriLumiere ? 1 : 0;
    data['fridge'] = fridge ? 1 : 0;
    data['risque'] = risque ? 1 : 0;
    return data..addAll(super.asMap());
  }

  List<String> asList() {
    return [
      id.toString(),
      libelle1,
      libelle2,
      family,
      subFamily,
      codeMedial,
      quantity.toString(),
      lieu,
      modality,
      dotation,
      toxicity.toString(),
      barCode,
      abriLumiere == true ? 'yes' : 'non',
      fridge == true ? 'yes' : 'non',
      risque == true ? 'yes' : 'non',
    ];
  }

  @override
  void fromMap(Map<String, dynamic> data) {
    libelle1 = data['libelle1'].toString();
    libelle2 = data['libelle2'].toString();
    family = data['family'].toString();
    subFamily = data['subfamily'].toString();
    codeMedial = data['medial'].toString();
    quantity = int.parse(data['quantity'].toString());
    lieu = data['lieu'].toString();
    modality = data['modality'].toString();
    dotation = data['dotation'].toString();
    toxicity = int.parse(data['toxicity'].toString());
    barCode = data['barcode'].toString();
    abriLumiere = data['abri'] == 1 ? true : false;
    fridge = data['fridge'] == 1 ? true : false;
    risque = data['risque'] == 1 ? true : false;
    super.fromMap(data);
  }
}

class ProductController extends Controller<Product> {
  ProductController(Database db) : super(Product.tableName, db);

  List<Product> products = [];

  Future<List<Product>> gets() async {
    List<Map<String, dynamic>> budgetListQuery = [];

    budgetListQuery = await db.query(table);
    for (var localBudget in budgetListQuery) {
      products.add(Product.fromMap(localBudget));
    }
    return products;
  }

  Future<void> deleteAll() async {
    products.clear();
  }

  void speedInsert(Product model) {
    products.add(model);
  }

  Future<void> insertOnlyDatabase(Product model) async {
    await super.insert(model);
  }

  Stream<void> batchInsertAllDatabase() async* {
    Batch batch = db.batch();
    for (var p in products) {
      batch.insert(table, p.asMap());
      yield ();
    }
    var result = await batch.commit();
    int i = 0;
    for (var p in products) {
      p.id = result[i] as int;
      i++;
    }
  }

  @override
  Future<Product> insert(Product model) async {
    Product product = await super.insert(model);
    products.add(product);
    return product;
  }
}
