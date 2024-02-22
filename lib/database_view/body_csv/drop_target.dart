import 'dart:io';
import 'dart:math';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class CsvDropTarget extends StatefulWidget {
  final String? error;

  final void Function(String?) onError;

  final TextEditingController controller;

  final void Function() selectFile;

  final void Function(String) onFileAccepted;

  const CsvDropTarget(
      {super.key,
      this.error,
      required this.onError,
      required this.controller,
      required this.selectFile,
      required this.onFileAccepted});

  @override
  State<StatefulWidget> createState() => CsvDropTargetState();
}

class CsvDropTargetState extends State<CsvDropTarget> {
  bool dragging = false;
  String fileData = "";

  Future<void> onDragDone(DropDoneDetails details) async {
    widget.onError(null);
    var xFile = details.files.single;
    try {
      if (xFile.name.split('.').last != "csv") {
        widget.onError("doit etre un fichier csv");
        return;
      }
    } catch (e) {
      widget.onError("doit etre un fichier csv");
      return;
    }
    File file = File(xFile.path);
    Stream<List<int>> data = file.openRead();
    await data.forEach((element) {
      fileData = "$fileData${String.fromCharCodes(element)}";
    });
    widget.onFileAccepted(fileData);
    setState(() => widget.controller.text = xFile.name);
  }

  @override
  Widget build(BuildContext context) {
    double minHeight = MediaQuery.of(context).size.height * 0.1;
    double minWidth = MediaQuery.of(context).size.width * 0.1;

    return Container(
      padding: const EdgeInsets.all(8),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: dragging ? Colors.black12 : null,
      ),
      child: DropTarget(
        onDragDone: onDragDone,
        onDragEntered: (_) => setState(() => dragging = true),
        onDragExited: (_) => setState(() => dragging = false),
        child: Builder(builder: (context) {
          if (minHeight < 20 || minWidth < 30) return const SizedBox.shrink();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Glissez et déposer votre fichier ici 📁", maxLines: 1),
                  Text("un fichier CSV est attendu", maxLines: 1),
                ],
              ),
              SizedBox(
                  height: min(minHeight, minWidth),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: dragging
                          ? const Icon(Icons.file_download_outlined, size: 40)
                          : Image.asset('images/csv_icon.png'))),
              Builder(builder: (context) {
                if (minHeight < 30) return const SizedBox.shrink();
                return SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AbsorbPointer(
                            absorbing: true,
                            child: TextField(
                              controller: widget.controller,
                              decoration:
                                  InputDecoration(errorText: widget.error),
                            )),
                      )),
                      Builder(builder: (context) {
                        if (minWidth * 0.1 < 30) return const SizedBox.shrink();
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: MaterialButton(
                              color: Colors.blue,
                              autofocus: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              onPressed: () => widget.selectFile(),
                              child: const Text('Ouvrir')),
                        );
                      })
                    ],
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}
