import 'dart:math';

import 'package:etiquette/database/preferences.dart';
import 'package:etiquette/database/product.dart';
import 'package:etiquette/printer/printer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PaintingTicketPaysage {
  static Widget generate(
      Product product, PdfColor dotationPdfColor, PdfColor toxicityPdfColor, Font? ttf) {
    List images = PrinterTicker().images;
    double fontSize = Preferences().publipostage.largeurEtiquette / 0.79375;
    return Stack(children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Flexible(
            flex: 39,
            child: Transform.rotateBox(
                angle: pi / 2,
                child: AspectRatio(
                    aspectRatio: 1,
                    child: Row(children: [
                      Spacer(),
                      Flexible(
                          flex: 8,
                          child: BarcodeWidget(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            data: product.barCode,
                            textStyle: TextStyle(font: ttf),
                            textPadding: 2,
                            barcode: Barcode.fromType(BarcodeType.Code128),
                            backgroundColor: PdfColor.fromHex("#FFFFFF"),
                          )),
                      Spacer()
                    ])))),
        Spacer(),
      ]),
      Row(children: [
        Flexible(flex: 2, child: Container(color: const PdfColor(1, 1, 1))),
        Flexible(
            flex: 28,
            child: Column(children: [
              Flexible(child: Container(color: const PdfColor(1, 1, 1))),
              Flexible(child: Container(color: dotationPdfColor)),
              Flexible(child: Container(color: const PdfColor(1, 1, 1))),
              Flexible(
                  flex: 13,
                  child: Container(
                      color: const PdfColor(1, 1, 1),
                      child: Column(children: [
                        Flexible(
                          flex: 40,
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 1.5, right: 1.5),
                              padding: const EdgeInsets.only(top: 2.0),
                              decoration: BoxDecoration(
                                  color: const PdfColor(1, 1, 1),
                                  border: Border(
                                    left: BorderSide(
                                        color: PdfColor.fromHex("#009688"),
                                        width: 3),
                                    top: BorderSide(
                                        color: PdfColor.fromHex("#009688"),
                                        width: 3),
                                    right: BorderSide(
                                        color: PdfColor.fromHex("#009688"),
                                        width: 3),
                                  )),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Text(
                                            "${product.libelle1} / ${product.libelle2}",
                                            style: TextStyle(
                                                fontSize: fontSize,
                                                font: ttf,
                                                letterSpacing: 0),
                                            maxLines: 2)),
                                    Spacer(),
                                    Expanded(
                                        flex: 10,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0),
                                                  child: Row(children: [
                                                    Flexible(
                                                        flex: 3,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
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
                                                                maxLines: 1))),
                                                    Flexible(
                                                        flex: 5,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                                'SER. ${product.modality}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontSize,
                                                                    font: ttf,
                                                                    color:
                                                                        const PdfColor(
                                                                            0.4,
                                                                            0.4,
                                                                            0.4)),
                                                                maxLines: 1))),
                                                  ])),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0),
                                                  child: Row(children: [
                                                    Flexible(
                                                        flex: 3,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
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
                                                                maxLines: 1))),
                                                    Flexible(
                                                        flex: 5,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                                product
                                                                    .dotation,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontSize,
                                                                    font: ttf,
                                                                    color:
                                                                        const PdfColor(
                                                                            0.4,
                                                                            0.4,
                                                                            0.4)),
                                                                maxLines: 1))),
                                                  ])),
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 2.0),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 2.0,
                                                              top: 1.0),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              toxicityPdfColor,
                                                          border: Border(
                                                            left: BorderSide(
                                                                color:
                                                                    toxicityPdfColor,
                                                                width: 3),
                                                            right: BorderSide(
                                                                color:
                                                                    toxicityPdfColor,
                                                                width: 3),
                                                            top: BorderSide(
                                                                color:
                                                                    toxicityPdfColor,
                                                                width: 3),
                                                            bottom: BorderSide(
                                                                color:
                                                                    toxicityPdfColor,
                                                                width: 3),
                                                          )),
                                                      child: Center(
                                                          child: Text(
                                                              "Respecter les doses prescrites",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontSize *
                                                                          0.75, font: ttf,),
                                                              maxLines: 1))))
                                            ]))
                                  ])),
                        ),
                        Spacer(flex: 2),
                        Flexible(
                            flex: 16,
                            child: Row(children: [
                              Flexible(child:
                                  Center(child: Builder(builder: (context) {
                                if (product.risque == false) {
                                  return SizedBox.shrink();
                                }
                                return Image(images[1], dpi: 300);
                              }))),
                              Flexible(child:
                                  Center(child: Builder(builder: (context) {
                                if (product.fridge == false) {
                                  return SizedBox.shrink();
                                }
                                return Image(images[2], dpi: 300);
                              }))),
                              Flexible(child:
                                  Center(child: Builder(builder: (context) {
                                if (product.abriLumiere == false) {
                                  return SizedBox.shrink();
                                }
                                return Image(images[0], dpi: 300);
                              }))),
                            ])),
                        Spacer(flex: 2),
                      ])))
            ])),
        Flexible(child: Container(color: const PdfColor(1, 1, 1))),
        Spacer(flex: 7),
      ]),
    ]);
  }
}
