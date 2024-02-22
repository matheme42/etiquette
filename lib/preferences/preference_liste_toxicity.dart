import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../database/preferences.dart';

class PreferenceToxicity extends StatefulWidget {
  const PreferenceToxicity({super.key});

  @override
  State<StatefulWidget> createState() => PreferenceToxicityState();
}

class PreferenceToxicityState extends State<PreferenceToxicity> {
  int? selectedIndex;

  Timer? timer;

  void onChangeColor(Color color) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 300), () {
      Preferences().updateToxicityColorList();
      timer = null;
    });
    setState(() {
      Preferences().toxicityColorList[selectedIndex!] = color;
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Align(
              alignment: Alignment.topLeft,
              child: RawScrollbar(
                controller: scrollController,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.04),
                      border: const Border(right: BorderSide())),
                  child: FractionallySizedBox(
                    heightFactor: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 25,
                          child: Row(children: [
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Divider(
                                color: Colors.black54,
                              ),
                            )),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('niveaux de toxicités'),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Divider(
                                color: Colors.black54,
                              ),
                            )),
                          ]),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: List<Widget>.generate(
                                    Preferences().toxicityColorList.length + 1,
                                    (index) {
                                  if (index ==
                                      Preferences().toxicityColorList.length) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: MaterialButton(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          color: Colors.green,
                                          onPressed: () {
                                            setState(() {
                                              Preferences()
                                                  .toxicityColorList
                                                  .add(const Color(0xFF6f5442));
                                              selectedIndex = Preferences()
                                                      .toxicityColorList
                                                      .length -
                                                  1;
                                              Preferences()
                                                  .updateToxicityColorList();
                                            });
                                          },
                                          child: const Text("Ajouter"),
                                        ),
                                      ),
                                    );
                                  }
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                    title: Text("niveau $index"),
                                    trailing: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(),
                                          color: Preferences()
                                              .toxicityColorList[index]),
                                    ),
                                  );
                                })),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Builder(builder: (context) {
            if (selectedIndex == null) {
              return const Center(child: Text('Aucune selection'));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Niveau $selectedIndex", maxLines: 1),
                      ),
                      HueRingPicker(
                          colorPickerHeight: 150,
                          enableAlpha: true,
                          portraitOnly: true,
                          pickerColor:
                              Preferences().toxicityColorList[selectedIndex!],
                          onColorChanged: onChangeColor),
                      Builder(builder: (context) {
                        if (selectedIndex !=
                            Preferences().toxicityColorList.length - 1) {
                          return const SizedBox.shrink();
                        }
                        return FractionallySizedBox(
                          widthFactor: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                                color: Colors.deepOrange,
                                onPressed: () {
                                  Preferences().toxicityColorList.removeLast();
                                  Preferences().updateToxicityColorList();
                                  setState(() => selectedIndex = null);
                                },
                                child: const Text("Retirer ce niveau")),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            );
          }))
        ],
      ),
    );
  }
}
