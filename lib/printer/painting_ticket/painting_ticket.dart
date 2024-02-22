import 'dart:ui';

import 'package:etiquette/database/preferences.dart';
import 'package:etiquette/database/product.dart';
import 'package:etiquette/extensions.dart';
import 'package:etiquette/printer/painting_ticket/paysage.dart';
import 'package:etiquette/printer/painting_ticket/portrait.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';



class PaintingTicket {
  static Widget generateTicket(Product product, bool isLandscape, Font? ttf) {
    Color dotationColor = const Color(0xffffffff);
    if (Preferences().softDotationTextList.contains(product.softDotation)) {
      int index = Preferences().softDotationTextList.indexOf(product.softDotation);
      dotationColor = Preferences().dotationColorList[index];
    }
    PdfColor dotationPdfColor = PdfColor(dotationColor.red / 255,
        dotationColor.green / 255, dotationColor.blue / 255);

    Color toxicityColor = const Color(0xffffffff);
    if (product.toxicity < Preferences().toxicityColorList.length &&
        product.toxicity >= 0) {
      toxicityColor = Preferences().toxicityColorList[product.toxicity];
    }
    PdfColor toxicityPdfColor = PdfColor(toxicityColor.red / 255,
        toxicityColor.green / 255, toxicityColor.blue / 255);

    PublipostagePreferences pref = Preferences().publipostage;
    double ratio = pref.hauteurEtiquette / pref.largeurEtiquette;
    if (ratio > 0.7) {
      return Center(
          child: Text(
              "Impossible de generer les etiquettes\nles dimensions de l'etiquette sont incorrects\n pour ce design en mode paysage\n minimum: hauteur / largeur <= 0.7 ($ratio)\n",
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center));
    }

    if (isLandscape) {
      return PaintingTicketPaysage.generate(
          product, dotationPdfColor, toxicityPdfColor, ttf);
    }
    return PaintingTicketPortrait.generate(
        product, dotationPdfColor, toxicityPdfColor, ttf);
  }
}