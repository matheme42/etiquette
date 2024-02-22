import 'dart:math';

import 'package:etiquette/database/basket.dart';
import 'package:etiquette/database/preferences.dart';
import 'package:etiquette/database/product.dart';
import 'package:etiquette/printer/printer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'painting_ticket/painting_ticket.dart';

class PositionnedTicket {
  static List<Widget> generate(
      {required PublipostagePreferences pref,
      required int number,
      required EtiquetteSelectionPage selections,
     Font? ttf
      }) {
    double stepX = max(pref.largeurEtiquette, pref.pasHorizontal);
    double stepY = max(pref.hauteurEtiquette, pref.pasVertical);
    double deadZoneWidth = pref.largeurPage -
        (pref.nbEtiquetteHorizontal * stepX) -
        pref.margeLaterale;
    double deadZoneHeight = pref.hauteurPage -
        (pref.nbEtiquetteVertical * stepY) -
        pref.margeSuperieur;

    double ratioTicketWidth = pref.largeurEtiquette / stepX;
    double ratioTicketHeight = pref.hauteurEtiquette / stepY;

    double ticketRatioWidth =
        stepX / (pref.largeurPage - deadZoneWidth - pref.margeLaterale);
    double ticketRatioHeight =
        stepY / (pref.hauteurPage - deadZoneHeight - pref.margeSuperieur);

    return List.generate(number, (int index) {
      int posX = (index % pref.nbEtiquetteHorizontal);
      int posY = (index / pref.nbEtiquetteHorizontal).floor();

      ProductSelection? productSelection;
      int ticketNumberCurrent = 0;
      for (var elm in selections.products) {
        productSelection = elm;
        ticketNumberCurrent += elm.number;
        if (ticketNumberCurrent > index) break;
      }

      return Align(
          alignment: const Alignment(-1, 1),
          child: generateOneTicket(
              pref: pref,
              ticketRatioWidth: ticketRatioWidth,
              ticketRatioHeight: ticketRatioHeight,
              posX: posX,
              posY: posY,
              ratioTicketWidth: ratioTicketWidth,
              ratioTicketHeight: ratioTicketHeight,
              product: productSelection!.product,
              isLandscape: productSelection.landscape,
              ttf: ttf
          ));
    });
  }

  static Widget generateOneTicket({
    required PublipostagePreferences pref,
    required double ticketRatioWidth,
    required double ticketRatioHeight,
    required int posX,
    required int posY,
    required double ratioTicketWidth,
    required double ratioTicketHeight,
    required Product product,
    required bool isLandscape,
    Font? ttf
  }) {
    int precision = 100000;
    double ticketFlexSizeWidth = ticketRatioWidth * precision;
    double ticketFlexSizeHeight = ticketRatioHeight * precision;

    int flexTop = (ticketFlexSizeHeight * posY).ceil();
    int flexBottom = precision - (ticketFlexSizeHeight * (posY + 1)).ceil();

    int flexLeft = (ticketFlexSizeWidth * posX).ceil();
    int flexRight = precision - (ticketFlexSizeWidth * (posX + 1)).ceil();

    if (flexTop <= 0) flexTop = 1;
    if (flexBottom <= 0) flexBottom = 1;
    if (flexLeft <= 0) flexLeft = 1;
    if (flexRight <= 0) flexRight = 1;

    int flexPadWidth = ((1 - ratioTicketWidth) * precision).floor();
    if (flexPadWidth == 0) flexPadWidth = 1;

    int flexPadHeight = ((1 - ratioTicketHeight) * precision).floor();
    if (flexPadHeight == 0) flexPadHeight = 1;

    return Column(children: [
      Spacer(flex: flexTop),
      Flexible(
          flex: ticketFlexSizeHeight.floor(),
          child: Row(children: [
            Spacer(flex: flexLeft),
            Flexible(
                flex: ticketFlexSizeWidth.floor(),
                child: Container(
                    child: Row(children: [
                  Flexible(
                      flex: (ratioTicketWidth * precision).ceil(),
                      child: Column(children: [
                        Flexible(
                            flex: (ratioTicketHeight * precision).ceil(),
                            child: Container(
                                decoration: const BoxDecoration(
                                  color: PdfColor(1, 1, 1),
                                ),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: PaintingTicket.generateTicket(
                                        product, isLandscape, ttf)))),
                        Spacer(flex: flexPadHeight)
                      ])),
                  Spacer(flex: flexPadWidth),
                ]))),
            Spacer(flex: flexRight),
          ])),
      Spacer(flex: flexBottom)
    ]);
  }
}
