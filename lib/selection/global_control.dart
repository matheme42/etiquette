import 'package:etiquette/selection/text_field.dart';
import 'package:flutter/material.dart';

import 'dropdown.dart';

class GlobalControl extends StatelessWidget {
  final TextEditingController controller;
  final void Function() onTextChange;
  final void Function(String) onOrientationChange;
  final void Function() onClickAddButton;

  const GlobalControl(
      {super.key,
      required this.controller,
      required this.onTextChange,
      required this.onOrientationChange,
      required this.onClickAddButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 250,
              height: 30,
              child: SelectionDropDown(onChange: onOrientationChange)),
          SelectionTextField(controller: controller, onChange: onTextChange),
          MaterialButton(
            color: Colors.green,
            onPressed: onClickAddButton,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            child: const Text('Ajouter'),
          )
        ],
      ),
    );
  }
}
