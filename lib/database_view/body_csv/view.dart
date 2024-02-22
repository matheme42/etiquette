import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'drop_target.dart';

class ImportCsvFile extends StatefulWidget {
  final void Function(String? fileData) onValidateImportation;

  const ImportCsvFile({super.key, required this.onValidateImportation});

  @override
  State<StatefulWidget> createState() => ImportCsvFileState();
}

class ImportCsvFileState extends State<ImportCsvFile> {
  String? error;
  String? fileData;

  TextEditingController controller = TextEditingController();

  Future<void> selectFile() async {
    setState(() => error = null);
    FilePicker filePicker = FilePicker.platform;
    FilePickerResult? result;
    result = await filePicker
        .pickFiles(allowedExtensions: ['csv'], lockParentWindow: true);

    if (result != null) {
      if (result.files.single.extension != "csv") {
        setState(() => error = "doit etre un fichier csv");
        return;
      }

      File file = File(result.files.single.path!);
      Stream<List<int>> data = file.openRead();
      await data.forEach((element) {
        fileData = "$fileData${String.fromCharCodes(element)}";
      });
      setState(() => controller.text = result!.files.single.name);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    double minHeight = MediaQuery.of(context).size.height * 0.1;
    double minWidth = MediaQuery.of(context).size.width * 0.1;

    return Focus(
      autofocus: true,
      child: Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: InkWell(
                        onTap: () => selectFile(),
                        onLongPress: () => selectFile(),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                            border: Border.all(
                                color: error != null
                                    ? Colors.red
                                    : Colors.black87),
                          ),
                          child: CsvDropTarget(
                            onError: (data) => setState(() => error = data),
                            controller: controller,
                            selectFile: selectFile,
                            onFileAccepted: (data) =>
                                setState(() => fileData = data),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: minHeight > 30 || minWidth < 30,
                    child: Visibility(
                      visible: controller.text.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MaterialButton(
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () =>
                              widget.onValidateImportation(fileData),
                          child: Text(
                            minWidth < 30
                                ? "Importer"
                                : "Valider l'importation",
                            style: TextStyle(fontSize: minWidth < 30 ? 10 : 14),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: !(minHeight > 30 || minWidth < 30),
                child: Visibility(
                  visible: controller.text.isNotEmpty,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      onPressed: () => widget.onValidateImportation(fileData),
                      child: Text(
                        minWidth < 50 ? "Importer" : "Valider l'importation",
                        style: TextStyle(fontSize: minWidth < 50 ? 10 : 14),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
