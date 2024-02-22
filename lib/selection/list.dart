import 'package:etiquette/database/basket.dart';
import 'package:etiquette/selection/text_field.dart';
import 'package:flutter/material.dart';

import '../database/product.dart';
import 'dropdown.dart';
import 'global_control.dart';

class SelectionList extends StatefulWidget {
  final List<Product> products;

  const SelectionList({super.key, required this.products});

  @override
  State<StatefulWidget> createState() => SelectionListState();
}

class SelectionListState extends State<SelectionList> {
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "ne peut pas etre vide";
    }
    int? val = int.tryParse(value);
    if (val == null || val <= 0) {
      return "valeur incorrect";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    controllers = List<TextEditingController>.generate(
        widget.products.length, (index) => TextEditingController(text: "1"),
        growable: false);
    dropDownKey = List.generate(widget.products.length, (index) {
      return GlobalKey<SelectionDropDownState>();
    });
  }

  TextEditingController globalController = TextEditingController(text: "1");
  List<TextEditingController> controllers = [];
  List<GlobalKey<SelectionDropDownState>> dropDownKey = [];

  GlobalKey<FormState> formKey = GlobalKey();

  void onClickAddButton() {
    List<ProductSelection> productSelections =
        List.generate(widget.products.length, (index) {
      bool landscape =
          dropDownKey[index].currentState?.selectedValue == "Paysage";
      return ProductSelection(widget.products[index],
          int.parse(controllers[index].text), ProductSelection.nextSelectionId ,landscape);
    });
    ProductSelection.nextSelectionId++;
    Basket().productSelections.addAll(productSelections);
    Basket().updateSharedPreference().then((value) {
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.black12,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(8))),
              child: GlobalControl(
                  controller: globalController,
                  onTextChange: () {
                    formKey.currentState?.validate();
                    if (validator(globalController.text) == null) {
                      for (var e in controllers) {
                        e.text = globalController.text;
                      }
                      setState(() {});
                    }
                  },
                  onOrientationChange: (value) {
                    for (var e in dropDownKey) {
                      e.currentState?.setValue(value);
                    }
                  },
                  onClickAddButton: onClickAddButton),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    Product product = widget.products[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "${product.codeMedial} > ${product.libelle1}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                        height: 30,
                                        width: 250,
                                        child: SelectionDropDown(
                                            onChange: (value) {},
                                            key: dropDownKey[index])),
                                    SelectionTextField(
                                        controller: controllers[index],
                                        onChange: () {
                                          formKey.currentState?.validate();
                                        }),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${product.lieu} > ${product.dotation}  > ${product.modality}",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 24.0),
                                    child: Text(
                                        "x ${product.quantity.toString()}"),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
