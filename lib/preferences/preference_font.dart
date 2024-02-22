
import 'dart:io';
import 'dart:typed_data';

import 'package:etiquette/printer/printer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PreferenceFont extends StatefulWidget {
  const PreferenceFont({super.key});

  @override
  State<StatefulWidget> createState() => PreferenceFontState();
}

class PreferenceFontState extends State<PreferenceFont> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    try {
      controller = TextEditingController(text: PrinterTicker().ttf?.fontName);
    } catch (e) {
      controller = TextEditingController();
    }
    PrinterTicker().addListener(onTtfChange);
  }

  void onTtfChange() {
    controller.text = PrinterTicker().ttf?.fontName ?? controller.text;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    PrinterTicker().removeListener(onTtfChange);
    super.dispose();
  }

  Future<void> selectFile() async {
    FilePicker filePicker = FilePicker.platform;
    String? fileData;
    var messenger = ScaffoldMessenger.of(context);
    FilePickerResult? result;
    result = await filePicker
        .pickFiles(allowedExtensions: ['ttf'], lockParentWindow: true);

    if (result != null) {
      if (result.files.single.extension != "ttf") {
        SnackBar snackBar =
        const SnackBar(content: Text('doit etre un fichier ttf'));
        messenger.showSnackBar(snackBar);
        return;
      }

      File file = File(result.files.single.path!);

      Uint8List list = file.readAsBytesSync();
      PrinterTicker().loadFontFromUint8List(list);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 0.8,
            child: MaterialButton(
              onPressed: () => selectFile(),
              padding: EdgeInsets.zero,
              child: AbsorbPointer(
                absorbing: true,
                child: TextField(
                  mouseCursor: SystemMouseCursors.click,
                    readOnly: true,
                    controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder()
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}