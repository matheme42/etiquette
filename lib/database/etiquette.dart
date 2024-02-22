import 'package:etiquette/database/database_controller.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Etiquette extends Model {
  static const String tableName = "Etiquette";

  Etiquette();

  Etiquette.initial() {
    name = "L7160";

    supMargin = 1.51;
    latMargin = 0.72;

    horizontalStep = 6.60;
    verticalStep = 3.81;

    ticketHeight = 3.81;
    ticketWidth = 6.35;

    pageName = "Personnaliser";

    ticketNumberHorizontal = 3;
    ticketNumberVertical = 7;

    pageWidth = 21.0;
    pageHeight = 29.69;
  }

  String name = "";

  double supMargin = 0;
  double latMargin = 0;

  double ticketHeight = 0;
  double ticketWidth = 0;

  double verticalStep = 0;
  double horizontalStep = 0;

  int ticketNumberHorizontal = 0;
  int ticketNumberVertical = 0;

  String pageName = "";
  double pageWidth = 0;
  double pageHeight = 0;

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> data = {};
    data['name'] = name;
    data['margelaterale'] = latMargin;
    data['margesuperieur'] = supMargin;
    data['hauteuretiquette'] = ticketHeight;
    data['largeuretiquette'] = ticketWidth;
    data['stepvertical'] = verticalStep;
    data['stephorizontal'] = horizontalStep;
    data['nbetiquettehoriz'] = ticketNumberHorizontal;
    data['nbetiquettevert'] = ticketNumberVertical;
    data['pagename'] = pageName;
    data['pagelargeur'] = pageWidth;
    data['pagehauteur'] = pageHeight;
    return data..addAll(super.asMap());
  }

  @override
  void fromMap(Map<String, dynamic> data) {
    name = data['name'] ?? name;
    latMargin = data['margelaterale'] ?? latMargin;
    supMargin = data['margesuperieur'] ?? supMargin;
    ticketHeight = data['hauteuretiquette'] ?? ticketHeight;
    ticketWidth = data['largeuretiquette'] ?? ticketWidth;
    verticalStep = data['stepvertical'] ?? verticalStep;
    horizontalStep = data['stephorizontal'] ?? horizontalStep;
    ticketNumberHorizontal = data['nbetiquettehoriz'] ?? ticketNumberHorizontal;
    ticketNumberVertical = data['nbetiquettevert'] ?? ticketNumberVertical;
    pageName = data['pagename'] ?? pageName;
    pageWidth = data['pagelargeur'] ?? pageWidth;
    pageHeight = data['pagehauteur'] ?? pageHeight;
    super.fromMap(data);
  }
}

class EtiquetteController extends Controller<Etiquette> {
  EtiquetteController(Database db) : super(Etiquette.tableName, db);

  List<Etiquette> etiquettes = [];

  Future<List<Etiquette>> gets() async {
    etiquettes.clear();
    List<Map<String, dynamic>> etiquetteListQuery = [];

    etiquetteListQuery = await db.query(table);
    for (var etiquette in etiquetteListQuery) {
      etiquettes.add(Etiquette()..fromMap(etiquette));
    }
    return etiquettes;
  }

  Future<void> deleteAll() async {
    etiquettes.clear();
  }

  @override
  Future<int> delete(Etiquette model) async {
    etiquettes.remove(model);
    return super.delete(model);
  }

  @override
  Future<Etiquette> insert(Etiquette model) async {
    Etiquette etiquette = await super.insert(model);
    etiquettes.add(etiquette);
    return etiquette;
  }
}
