import 'dart:ui';

import 'package:etiquette/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'etiquette.dart';


class InitialValue {
 static List<String> defaultToxicityColor = ["16777215", "4292814361", "4285254490"];

 static Etiquette defaultEtiquette = Etiquette.initial();

 static const String ticketName = "L7160";

 static const double supMargin = 1.51;
 static const double latMargin = 0.72;

 static const double horizontalStep = 6.60;
 static const double verticalStep = 3.81;

 static const double ticketHeight = 3.81;
 static const double ticketWidth = 6.35;

 static const String pageName = "Personnaliser";

 static const int ticketNumberHorizontal = 3;
 static const int ticketNumberVertical = 7;

 static const double pageWidth = 21.0;
 static const double pageHeight = 29.69;
}

class PublipostagePreferences {
  late SharedPreferences pref;

  PublipostagePreferences();

  Size? convertSheetFormatToSize() {
    switch (_pageFormat) {
      case "Lettre":
        return const Size(29.59, 27.94);
      case "Lettre US":
        return const Size(27.94, 21.59);
      case "A3":
        return const Size(29.70, 42.00);
      case "Paysage A3":
        return const Size(42.00, 29.70);
      case "A4":
        return const Size(21.00, 29.00);
      case "Paysage A4":
        return const Size(29.00, 21.00);
      case "A5":
        return const Size(14.80, 21.00);
      case "Paysage A5":
        return const Size(21.00, 14.80);
      case "A6":
        return const Size(10.50, 14.80);
      case "Paysage A6":
        return const Size(14.80, 10.50);
      case "JIS B5":
        return const Size(18.20, 25.70);
      case "Mini":
        return const Size(10.48, 12.70);
      case "Demi-page verticale":
        return const Size(10.79, 25.40);
      case "Paysage Demi-page verticale":
        return const Size(25.40, 10.79);
      case "Hagaki":
        return const Size(10.00, 14.80);
      case "Paysage Hagaki":
        return const Size(14.80, 10.00);
      case "JIS B4":
        return const Size(27.70, 36.40);
      default:
        return null;
    }
  }

  Etiquette toEtiquette() {
    Etiquette etiquette = Etiquette();
    etiquette.name = _referenceEtiquette;
    etiquette.supMargin = _margeSuperieur;
    etiquette.latMargin = _margeLaterale;
    etiquette.horizontalStep = _pasHorizontal;
    etiquette.verticalStep = _pasVertical;
    etiquette.ticketHeight = _hauteurEtiquette;
    etiquette.ticketWidth = _largeurEtiquette;
    etiquette.pageName = _pageFormat;
    etiquette.ticketNumberHorizontal = _nbEtiquetteHorizontal;
    etiquette.ticketNumberVertical = _nbEtiquetteVertical;
    etiquette.pageWidth = _largeurPage;
    etiquette.pageHeight = _hauteurPage;
    return etiquette;
  }

  void fromDefaultValue() {
    referenceEtiquette = InitialValue.ticketName;
    margeSuperieur = InitialValue.supMargin;
    margeLaterale = InitialValue.latMargin;
    pasHorizontal = InitialValue.horizontalStep;
    pasVertical = InitialValue.verticalStep;
    hauteurEtiquette = InitialValue.ticketHeight;
    largeurEtiquette = InitialValue.ticketWidth;
    pageFormat = InitialValue.pageName;
    nbEtiquetteHorizontal = InitialValue.ticketNumberHorizontal;
    nbEtiquetteVertical = InitialValue.ticketNumberVertical;
    largeurPage = InitialValue.pageWidth;
    hauteurPage = InitialValue.pageHeight;
  }

  void fromEtiquette(Etiquette etiquette) {
    referenceEtiquette = etiquette.name;
    margeSuperieur = etiquette.supMargin;
    margeLaterale = etiquette.latMargin;
    pasHorizontal = etiquette.horizontalStep;
    pasVertical = etiquette.verticalStep;
    hauteurEtiquette = etiquette.ticketHeight;
    largeurEtiquette = etiquette.ticketWidth;
    pageFormat = etiquette.pageName;
    nbEtiquetteHorizontal = etiquette.ticketNumberHorizontal;
    nbEtiquetteVertical = etiquette.ticketNumberVertical;
    largeurPage = etiquette.pageWidth;
    hauteurPage = etiquette.pageHeight;
  }

  Future<void> init(SharedPreferences pref) async {
    this.pref = pref;
    _referenceEtiquette = pref.getString(_referenceEtiquettePrefKey) ?? InitialValue.ticketName;

    _margeSuperieur = pref.getDouble(_margeSuperieurPrefKey) ?? InitialValue.supMargin;
    _margeLaterale = pref.getDouble(_margeLateralePrefKey) ?? InitialValue.latMargin;

    _pasVertical = pref.getDouble(_pasVerticalPrefKey) ?? InitialValue.verticalStep;
    _pasHorizontal = pref.getDouble(_pasHorizontalPrefKey) ?? InitialValue.horizontalStep;

    _hauteurEtiquette = pref.getDouble(_hauteurEtiquettePrefKey) ?? InitialValue.ticketHeight;
    _largeurEtiquette = pref.getDouble(_largeurEtiquettePrefKey) ?? InitialValue.ticketWidth;

    _pageFormat = pref.getString(_pageFormatPrefKey) ?? InitialValue.pageName;

    _nbEtiquetteVertical = pref.getInt(_nbEtiquetteVerticalPrefKey) ?? InitialValue.ticketNumberVertical;
    _nbEtiquetteHorizontal = pref.getInt(_nbEtiquetteHorizontalPrefKey) ?? InitialValue.ticketNumberHorizontal;

    _hauteurPage = pref.getDouble(_hauteurPagePrefKey) ?? InitialValue.pageHeight;
    _largeurPage = pref.getDouble(_largeurPagePrefKey) ?? InitialValue.pageWidth;
  }

  String _referenceEtiquette = InitialValue.ticketName;
  final String _referenceEtiquettePrefKey = "referenceEtiquette";

  String get referenceEtiquette => _referenceEtiquette;

  set referenceEtiquette(String val) {
    _referenceEtiquette = val;
    pref.setString(_referenceEtiquettePrefKey, val);
  }

  // cm
  double _margeSuperieur = InitialValue.supMargin;
  final String _margeSuperieurPrefKey = "margeSuperieur";

  double get margeSuperieur => _margeSuperieur;

  set margeSuperieur(double val) {
    _margeSuperieur = val;
    pref.setDouble(_margeSuperieurPrefKey, val);
  }

  double _margeLaterale = InitialValue.latMargin;
  final String _margeLateralePrefKey = "margeLaterale";

  double get margeLaterale => _margeLaterale;

  set margeLaterale(double val) {
    _margeLaterale = val;
    pref.setDouble(_margeLateralePrefKey, val);
  }

  // cm
  double _pasVertical = InitialValue.verticalStep;
  final String _pasVerticalPrefKey = "pasVertical";

  double get pasVertical => _pasVertical;

  set pasVertical(double val) {
    _pasVertical = val;
    pref.setDouble(_pasVerticalPrefKey, val);
  }

  double _pasHorizontal = InitialValue.horizontalStep;
  final String _pasHorizontalPrefKey = "pasHorizontal";

  double get pasHorizontal => _pasHorizontal;

  set pasHorizontal(double val) {
    _pasHorizontal = val;
    pref.setDouble(_pasHorizontalPrefKey, val);
  }

  // cm
  double _hauteurEtiquette = InitialValue.ticketHeight;
  final String _hauteurEtiquettePrefKey = "hauteurEtiquette";

  double get hauteurEtiquette => _hauteurEtiquette;

  set hauteurEtiquette(double val) {
    _hauteurEtiquette = val;
    pref.setDouble(_hauteurEtiquettePrefKey, val);
  }

  double _largeurEtiquette = InitialValue.ticketWidth;
  final String _largeurEtiquettePrefKey = "largeurEtiquette";

  double get largeurEtiquette => _largeurEtiquette;

  set largeurEtiquette(double val) {
    _largeurEtiquette = val;
    pref.setDouble(_largeurEtiquettePrefKey, val);
  }

  String _pageFormat = InitialValue.pageName;
  final String _pageFormatPrefKey = "pageFormat";

  String get pageFormat => _pageFormat;

  set pageFormat(String val) {
    _pageFormat = val;
    Size? size = convertSheetFormatToSize();
    if (size != null) {
      hauteurPage = size.height;
      largeurPage = size.width;
    }
    pref.setString(_pageFormatPrefKey, val);
  }

  int _nbEtiquetteHorizontal = InitialValue.ticketNumberHorizontal;
  final String _nbEtiquetteHorizontalPrefKey = "nbEtiquetteHorizontal";

  int get nbEtiquetteHorizontal => _nbEtiquetteHorizontal;

  set nbEtiquetteHorizontal(int val) {
    _nbEtiquetteHorizontal = val;
    pref.setInt(_nbEtiquetteHorizontalPrefKey, val);
  }

  int _nbEtiquetteVertical = InitialValue.ticketNumberVertical;
  final String _nbEtiquetteVerticalPrefKey = "nbEtiquetteVertical";

  int get nbEtiquetteVertical => _nbEtiquetteVertical;

  set nbEtiquetteVertical(int val) {
    _nbEtiquetteVertical = val;
    pref.setInt(_nbEtiquetteVerticalPrefKey, val);
  }

  // cm
  double _hauteurPage = InitialValue.pageHeight;
  final String _hauteurPagePrefKey = "hauteurPage";

  double get hauteurPage => _hauteurPage;

  set hauteurPage(double val) {
    _hauteurPage = val;
    pref.setDouble(_hauteurPagePrefKey, val);
  }

  double _largeurPage = InitialValue.pageWidth;
  final String _largeurPagePrefKey = "largeurPage";

  double get largeurPage => _largeurPage;

  set largeurPage(double val) {
    _largeurPage = val;
    pref.setDouble(_largeurPagePrefKey, val);
  }
}

class Preferences extends ChangeNotifier {
  static final Preferences _instance = Preferences._privateConstructor();
  static late SharedPreferences pref;

  Preferences._privateConstructor();

  factory Preferences() {
    return _instance;
  }

  final String _showOverlayPreferenceKey = "sheetFormat";

  bool _showOverlay = true;

  set showOverlay(bool val) {
    _showOverlay = val;
    pref.setBool(_showOverlayPreferenceKey, val);
    notifyListeners();
  }

  bool get showOverlay => _showOverlay;

  PublipostagePreferences publipostage = PublipostagePreferences();
  EtiquetteController? etiquetteController;

  final String _toxicityColorListPreferenceKey = "toxiciteList";
  final String _dotationColorPreferenceKey = "dotationList";
  final String _dotationTextPreferenceKey = "dotationTextList";

  List<Color> toxicityColorList = [];

  List<Color> dotationColorList = [];
  List<String> dotationTextList = [];
  List<String> softDotationTextList = [];


  Future<bool> updateDotationTextList() async {
    softDotationTextList.clear();
    for (var elm in dotationTextList) {
      softDotationTextList.add(elm.trim().toLowerCase().replaceAllDiacritics());
    }
    return await pref.setStringList(
        _dotationTextPreferenceKey, dotationTextList);
  }

  Future<bool> updateDotationColorList() async {
    List<String> colors = [];
    for (var element in dotationColorList) {
      colors.add(element.value.toString());
    }
    return await pref.setStringList(_dotationColorPreferenceKey, colors);
  }

  Future<bool> updateToxicityColorList() async {
    List<String> colors = [];
    for (var element in toxicityColorList) {
      colors.add(element.value.toString());
    }
    return await pref.setStringList(_toxicityColorListPreferenceKey, colors);
  }

  Future<void> clearSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  Future<void> init() async {
    pref = await SharedPreferences.getInstance();
    _showOverlay = pref.getBool(_showOverlayPreferenceKey) ?? true;

    await etiquetteController?.gets();
    await publipostage.init(pref);
    try {
      var lst = pref.getStringList(_toxicityColorListPreferenceKey);
      lst ??= InitialValue.defaultToxicityColor;
      for (var element in lst) {
        toxicityColorList.add(Color(int.parse(element)));
      }

      var lst2 = pref.getStringList(_dotationColorPreferenceKey);
      lst2?.forEach((element) {
        dotationColorList.add(Color(int.parse(element)));
      });
      dotationTextList = pref.getStringList(_dotationTextPreferenceKey) ?? [];
      softDotationTextList.clear();
      for (var elm in dotationTextList) {
        softDotationTextList.add(elm.trim().toLowerCase().replaceAllDiacritics());
      }
    } catch (e) {
      if (kDebugMode) {
        print("un probleme est survenu lors du chargement des preferences $e");
      }
    }
  }

  PdfPageFormat convertSheetFormatToPdfPageFormat() {
    const double inch = 72.0;
    const double cm = inch / 2.54;
    return PdfPageFormat(
        publipostage.largeurPage * cm, publipostage.hauteurPage * cm);
  }
}