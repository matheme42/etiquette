import 'dart:math';

import 'package:etiquette/database/preferences.dart';
import 'package:etiquette/printer/positionned_ticket.dart';
import 'package:etiquette/printer/printer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfPageGenerationEtiquette {
  static Page generate(PublipostagePreferences pref, PdfPageFormat format,
      EtiquetteSelectionPage selections, Font? ttf) {
    int nbEtiquette = 0;
    for (var element in selections.products) {
      nbEtiquette += element.number;
    }
    double stepWidth = max(pref.largeurEtiquette, pref.pasHorizontal);
    double stepHeight = max(pref.hauteurEtiquette, pref.pasVertical);
    double deadZoneWidth = pref.largeurPage -
        (pref.nbEtiquetteHorizontal * stepWidth) -
        pref.margeLaterale;
    double deadZoneHeight = pref.hauteurPage -
        (pref.nbEtiquetteVertical * stepHeight) -
        pref.margeSuperieur;

    double precision = 10000;
    double flexLeft = (pref.margeLaterale / pref.largeurPage) * precision;
    double flexRight = (deadZoneWidth / pref.largeurPage) * precision;

    double flexTop = (pref.margeSuperieur / pref.hauteurPage) * precision;
    double flexBottom = (deadZoneHeight / pref.hauteurPage) * precision;

    PdfColor marginColor = const PdfColor(1, 1, 1);
    return Page(
        pageFormat: format,
        build: (Context context) {
          return Row(children: [
            Flexible(
                flex: flexLeft.toInt(), child: Container(color: marginColor)),
            Flexible(
                flex: (precision - flexLeft - flexRight).ceil(),
                child: Column(children: [
                  Flexible(
                      flex: flexTop.toInt(),
                      child: Container(color: marginColor)),
                  Flexible(
                      flex: (precision - flexTop - flexBottom).ceil(),
                      child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.topLeft,
                          children: PositionnedTicket.generate(
                              pref: pref,
                              number: nbEtiquette,
                              selections: selections,
                            ttf: ttf

                          ))),
                  Flexible(
                      flex: flexBottom.toInt(),
                      child: Container(color: marginColor))
                ])),
            Flexible(
                flex: flexRight.toInt(), child: Container(color: marginColor))
          ]);
        });
  }
}
