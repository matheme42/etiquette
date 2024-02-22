import 'dart:io';
import 'dart:typed_data';

import 'package:etiquette/database/basket.dart';
import 'package:etiquette/database/preferences.dart';
import 'package:etiquette/printer/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EtiquetteSelectionPage {
  List<ProductSelection> products = [];
}

class PrinterTicker extends ChangeNotifier {
  PrinterTicker._privateConstructor();

  static final PrinterTicker _instance = PrinterTicker._privateConstructor();

  factory PrinterTicker() {
    return _instance;
  }

  List images = [];

  pw.Font? ttf;

  Future<void> loadFontFromUint8List(Uint8List data) async {
    Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    //Create path for database
    String path = join(appDocumentsDir.path, "etiquette", "font.ttf");
    File file = File(path);
    file.deleteSync();
    file.writeAsBytesSync(data);
    ttf = pw.Font.ttf(data.buffer.asByteData());
    notifyListeners();
  }

  String? error;

  Future<void> initialize() async {
    images.add(await imageFromAssetBundle('images/logo/abri_white.png',
        dpi: 300, cache: false));
    images.add(await imageFromAssetBundle('images/logo/dangeureux_white.png',
        dpi: 300, cache: false));
    images.add(await imageFromAssetBundle('images/logo/frigo_white.png',
        dpi: 300, cache: false));

    try {
      Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      //Create path for database
      String path = join(appDocumentsDir.path, "etiquette", "font.ttf");
      File file  = File(path);
      if (!file.existsSync()) {
        ttf = pw.Font.ttf(await rootBundle.load('fonts/Montserrat-Regular.ttf'));
      } else {
        ttf = pw.Font.ttf(file.readAsBytesSync().buffer.asByteData());
      }
    } catch (e) {
      error = e.toString();
    }

  }

  List<EtiquetteSelectionPage> _createPageSelection(int maxTicketOnPage) {
    List<EtiquetteSelectionPage> selectionPages = [];

    int etiquetteAvailableOnCurrentPage = maxTicketOnPage;
    EtiquetteSelectionPage currentPage = EtiquetteSelectionPage();
    for (var selection in Basket().productSelections) {
      int currentNumberOnSelection = selection.number;
      while (currentNumberOnSelection >= etiquetteAvailableOnCurrentPage) {
        currentPage.products.add(ProductSelection(selection.product,
            etiquetteAvailableOnCurrentPage, selection.id, selection.landscape));
        currentNumberOnSelection -= etiquetteAvailableOnCurrentPage;
        selectionPages.add(currentPage);
        currentPage = EtiquetteSelectionPage();
        etiquetteAvailableOnCurrentPage = maxTicketOnPage;
      }

      if (currentNumberOnSelection < etiquetteAvailableOnCurrentPage) {
        currentPage.products.add(ProductSelection(
            selection.product, currentNumberOnSelection, selection.id, selection.landscape));
        etiquetteAvailableOnCurrentPage -= currentNumberOnSelection;
        continue;
      }
    }
    if (etiquetteAvailableOnCurrentPage != maxTicketOnPage) {
      selectionPages.add(currentPage);
    }
    return selectionPages;
  }

  Future<pw.Document> generatePdf(PdfPageFormat format) async {
    PublipostagePreferences pref = Preferences().publipostage;
    int maxTicketOnPage = pref.nbEtiquetteHorizontal * pref.nbEtiquetteVertical;
    int ticketToGenerate = 0;
    for (var element in Basket().productSelections) {
      ticketToGenerate += element.number;
    }

    int numberPage = (ticketToGenerate / maxTicketOnPage).ceil();
    List<EtiquetteSelectionPage> etiquettePageSelection =
        _createPageSelection(maxTicketOnPage);
    pw.Document pdf = pw.Document(compress: false);
    for (int i = 0; i < numberPage; i++) {
      pdf.addPage(PdfPageGenerationEtiquette.generate(
          Preferences().publipostage, format, etiquettePageSelection[i], ttf));
    }
    return pdf;
  }

  Future<void> showPdfPreview(BuildContext context,
      [bool center = false]) async {
    var pdf =
        await generatePdf(Preferences().convertSheetFormatToPdfPageFormat());
    // ignore: use_build_context_synchronously
    return showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 0.74,
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(primaryColor: Colors.grey),
                            child: Center(
                              child: RotatedBox(
                                quarterTurns: 0,
                                child: PdfPreview(
                                  useActions: false,
                                  actions: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: PdfPrintAction(),
                                    )
                                  ],
                                  canDebug: false,
                                  build: (format) => pdf.save(),
                                  dynamicLayout: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: center ? 0 : 250)
            ],
          ),
        );
      },
    );
  }

  Future<void> printPdf(BuildContext context) async {
    var printer = await Printing.pickPrinter(context: context);
    if (printer == null) return;
    var pdf =
        await generatePdf(Preferences().convertSheetFormatToPdfPageFormat());
    await Printing.layoutPdf(
        onLayout: (_) => pdf.save(), usePrinterSettings: true);
  }
}
