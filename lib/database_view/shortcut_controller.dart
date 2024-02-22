import 'package:etiquette/database/basket.dart';
import 'package:etiquette/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/preferences.dart';
import '../printer/printer.dart';
import 'view.dart';

extension ShortcutController on DatabaseViewState {
  KeyEventResult onKeyEvent(FocusNode node, RawKeyEvent event) {
    if (event.isControlPressed && event is RawKeyDownEvent) {
      String key = event.logicalKey.keyLabel;
      switch (key) {
        case 'I':
          selectFile(true);
          break;
        case 'T':
          selectFile();
          break;
        case '1':
          PreferencesWindows.show(context, 0);
          break;
        case '2':
          PreferencesWindows.show(context, 1);
          break;
        case '3':
          PreferencesWindows.show(context, 2);
          break;
        case '4':
          PreferencesWindows.show(context, 3);
          break;
        case 'B':
          if (scaffoldKey.currentState?.isEndDrawerOpen == true) {
            scaffoldKey.currentState?.closeEndDrawer();
            break ;
          }
          scaffoldKey.currentState?.openEndDrawer();
          break;
        case 'E':
          if (Basket().productSelections.isNotEmpty) {
            PrinterTicker().showPdfPreview(context, true);
            break;
          }
          var messenger = ScaffoldMessenger.of(context);
          messenger.clearSnackBars();
          var snackBar = const SnackBar(
              content: Text("Rien a previsualiser"));
          messenger.showSnackBar(snackBar);          break;
        case 'P':
          if (Basket().productSelections.isNotEmpty) {
            PrinterTicker().printPdf(context);
            break;
          }
          var messenger = ScaffoldMessenger.of(context);
          messenger.clearSnackBars();
          var snackBar = const SnackBar(
              content: Text("Rien a imprimer"));
          messenger.showSnackBar(snackBar);
          break;
        case 'N':
          Basket().productSelections.clear();
          Basket().updateSharedPreference();
          break;
        case 'O':
          Preferences().showOverlay = !Preferences().showOverlay;
          break;
        default:
      }
    }
    return KeyEventResult.ignored;
  }
}