import 'dart:math';

import 'package:etiquette/database/preferences.dart';
import 'package:etiquette/database/product.dart';
import 'package:etiquette/printer/printer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PaintingTicketPortrait {
  static Widget generate(
      Product product, PdfColor dotationPdfColor, PdfColor toxicityPdfColor, Font? ttf) {
    List images = PrinterTicker().images;
    double fontSize = Preferences().publipostage.hauteurEtiquette / 0.47625;

    return Column(children: [
      Spacer(),
      Flexible(
          flex: 18,
          child: Row(children: [
            Spacer(flex: 2),
            Flexible(
                flex: 48,
                child: Row(children: [
                  Flexible(
                      flex: 2,
                      child: Container(
                          decoration: BoxDecoration(
                        color: dotationPdfColor,
                      ))),
                  Spacer(),
                  Flexible(
                      flex: 30,
                      child: Stack(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Transform.rotateBox(
                                  angle: pi / 2,
                                  child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Row(children: [
                                        Spacer(),
                                        Flexible(
                                            flex: 18,
                                            child: BarcodeWidget(
                                              margin: EdgeInsets.zero,
                                              padding: EdgeInsets.zero,
                                              data: product.barCode,
                                              textPadding: 2,
                                              textStyle: TextStyle(font: ttf),
                                              barcode: Barcode.fromType(
                                                  BarcodeType.Code128),
                                              backgroundColor:
                                                  PdfColor.fromHex("#FFFFFF"),
                                            )),
                                        Spacer()
                                      ])))
                            ]),
                        Row(children: [
                          Transform.rotateBox(
                              angle: pi / 2,
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 1.5, right: 1.5),
                                      padding: const EdgeInsets.only(top: 2.0),
                                      decoration: BoxDecoration(
                                          color: const PdfColor(1, 1, 1),
                                          border: Border(
                                            left: BorderSide(
                                                color:
                                                    PdfColor.fromHex("#009688"),
                                                width: 3),
                                            top: BorderSide(
                                                color:
                                                    PdfColor.fromHex("#009688"),
                                                width: 3),
                                            right: BorderSide(
                                                color:
                                                    PdfColor.fromHex("#009688"),
                                                width: 3),
                                          )),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Text(
                                                    "${product.libelle1} / ${product.libelle2}",
                                                    style: TextStyle(
                                                        fontSize: fontSize,
                                                        font: ttf,
                                                        letterSpacing: 0),
                                                    maxLines: 4)),
                                            Spacer(),
                                            Expanded(
                                                flex: 10,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          child: Text(
                                                              'ART.: ${product.codeMedial}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  font: ttf,
                                                                  color:
                                                                      const PdfColor(
                                                                          0.4,
                                                                          0.4,
                                                                          0.4)),
                                                              maxLines: 1)),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          child: Text(
                                                              'QUA.: ${product.quantity}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  font: ttf,
                                                                  color:
                                                                      const PdfColor(
                                                                          0.4,
                                                                          0.4,
                                                                          0.4)),
                                                              maxLines: 1)),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          child: Text(
                                                              'SERVICE / ${product.modality}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  font: ttf,
                                                                  color:
                                                                      const PdfColor(
                                                                          0.4,
                                                                          0.4,
                                                                          0.4)),
                                                              maxLines: 1)),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          child: Text(
                                                              product.dotation,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  font: ttf,
                                                                  color:
                                                                      const PdfColor(
                                                                          0.4,
                                                                          0.4,
                                                                          0.4)),
                                                              maxLines: 1)),
                                                      Align(
                                                          alignment: Alignment
                                                              .center,
                                                          child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 2.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          2.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color:
                                                                          toxicityPdfColor,
                                                                      border:
                                                                          Border(
                                                                        left: BorderSide(
                                                                            color:
                                                                                toxicityPdfColor,
                                                                            width:
                                                                                3),
                                                                        right: BorderSide(
                                                                            color:
                                                                                toxicityPdfColor,
                                                                            width:
                                                                                3),
                                                                        top: BorderSide(
                                                                            color:
                                                                                toxicityPdfColor,
                                                                            width:
                                                                                3),
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                toxicityPdfColor,
                                                                            width:
                                                                                3),
                                                                      )),
                                                              child: Center(
                                                                  child: Text(
                                                                      "Respecter les doses prescrites",
                                                                      style: TextStyle(
                                                                          fontSize: fontSize *
                                                                              0.75,
                                                                        font: ttf),
                                                                      maxLines:
                                                                          1))))
                                                    ]))
                                          ])))),
                          Expanded(
                              child: Row(children: [
                            Flexible(
                                child: Container(
                              color: const PdfColor(1, 1, 1),
                            )),
                            Flexible(
                                flex: 4,
                                child: Container(
                                    color: const PdfColor(1, 1, 1),
                                    child: Column(children: [
                                      Flexible(child: Center(
                                          child: Builder(builder: (context) {
                                        if (product.risque == false) {
                                          return SizedBox.shrink();
                                        }
                                        return Transform.rotate(
                                            angle: pi / 2,
                                            child: Image(images[1], dpi: 300));
                                      }))),
                                      Flexible(child: Center(
                                          child: Builder(builder: (context) {
                                        if (product.fridge == false) {
                                          return SizedBox.shrink();
                                        }
                                        return Transform.rotate(
                                            angle: pi / 2,
                                            child: Image(images[2], dpi: 300));
                                      }))),
                                      Flexible(child: Center(
                                          child: Builder(builder: (context) {
                                        if (product.abriLumiere == false) {
                                          return SizedBox.shrink();
                                        }
                                        return Transform.rotate(
                                            angle: pi / 2,
                                            child: Image(images[0], dpi: 300));
                                      }))),
                                    ]))),
                            Flexible(
                                child: Container(
                              color: const PdfColor(1, 1, 1),
                            )),
                            Spacer(flex: 7),
                          ]))
                        ]),
                      ]))
                ])),
            Spacer()
          ])),
      Spacer(),
    ]);
  }
}
