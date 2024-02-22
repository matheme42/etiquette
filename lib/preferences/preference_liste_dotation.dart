import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../database/preferences.dart';

class PreferenceDotation extends StatefulWidget {
  const PreferenceDotation({super.key});

  @override
  State<StatefulWidget> createState() => PreferenceDotationState();
}

class PreferenceDotationState extends State<PreferenceDotation> {
  int? selectedIndex;

  Timer? timer;

  ValueNotifier<bool> updateRightPanel = ValueNotifier(false);

  void onChangeColor(Color color) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 300), () {
      Preferences().updateDotationColorList();
      timer = null;
    });
    setState(() {
      Preferences().dotationColorList[selectedIndex!] = color;
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          SizedBox(
            width: 300,
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
                              child: Text('Listes des dotations'),
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
                                    Preferences().dotationColorList.length + 1,
                                    (index) {
                                  if (index ==
                                      Preferences().dotationColorList.length) {
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
                                                  .dotationColorList
                                                  .add(const Color(0xFF6f5442));
                                              Preferences()
                                                  .dotationTextList
                                                  .add("Placeholder $index");
                                              selectedIndex = Preferences()
                                                      .dotationColorList
                                                      .length -
                                                  1;
                                              Preferences()
                                                  .updateDotationColorList();
                                              Preferences()
                                                  .updateDotationTextList();
                                            });
                                          },
                                          child: const Text("Ajouter"),
                                        ),
                                      ),
                                    );
                                  }
                                  ValueNotifier editValue =
                                      ValueNotifier(false);
                                  FocusNode node = FocusNode();
                                  return ValueListenableBuilder(
                                      valueListenable: editValue,
                                      builder: (context, edit, _) {
                                        return ListTile(
                                          tileColor: Colors.transparent,
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                          },
                                          leading: edit == false
                                              ? IconButton(
                                                  onPressed: () {
                                                    editValue.value = true;
                                                  },
                                                  icon: const Icon(Icons.edit))
                                              : null,
                                          title: Builder(builder: (context) {
                                            if (edit) {
                                              var controller =
                                                  TextEditingController(
                                                      text: Preferences()
                                                              .dotationTextList[
                                                          index]);
                                              return TextField(
                                                focusNode: node,
                                                controller: controller,
                                                onEditingComplete: () {
                                                  node.unfocus();
                                                  Preferences()
                                                          .dotationTextList[
                                                      index] = controller.text;
                                                  Preferences()
                                                      .updateDotationTextList();
                                                  editValue.value = false;
                                                  updateRightPanel.value =
                                                      !updateRightPanel.value;
                                                },
                                                onTapOutside: (_) {
                                                  node.unfocus();
                                                  Preferences()
                                                          .dotationTextList[
                                                      index] = controller.text;
                                                  Preferences()
                                                      .updateDotationTextList();
                                                  editValue.value = false;
                                                  updateRightPanel.value =
                                                      !updateRightPanel.value;
                                                },
                                              );
                                            }
                                            return Tooltip(
                                                message: Preferences()
                                                    .dotationTextList[index],
                                                child: Text(
                                                    Preferences()
                                                            .dotationTextList[
                                                        index],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis));
                                          }),
                                          trailing: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(),
                                                color: Preferences()
                                                    .dotationColorList[index]),
                                          ),
                                        );
                                      });
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
          Expanded(
              child: ValueListenableBuilder(
                  valueListenable: updateRightPanel,
                  builder: (context, _, __) {
                    if (selectedIndex == null) {
                      return const Center(child: Text('Aucune selection'));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    Preferences()
                                        .dotationTextList[selectedIndex!],
                                    maxLines: 1),
                              ),
                              HueRingPicker(
                                  colorPickerHeight: 150,
                                  enableAlpha: true,
                                  portraitOnly: true,
                                  pickerColor: Preferences()
                                      .dotationColorList[selectedIndex!],
                                  onColorChanged: onChangeColor),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  onPressed: () {
                                    Preferences settings = Preferences();
                                    settings.dotationTextList
                                        .removeAt(selectedIndex!);
                                    settings.dotationColorList
                                        .removeAt(selectedIndex!);
                                    settings.updateDotationColorList();
                                    settings.updateDotationTextList();
                                    setState(() => selectedIndex = null);
                                  },
                                  color: Colors.deepOrange,
                                  child: const Text("Supprimer de la liste"),
                                ),
                              )
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
