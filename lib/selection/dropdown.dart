import 'package:flutter/material.dart';

class SelectionDropDown extends StatefulWidget {
  final void Function(String) onChange;

  const SelectionDropDown({super.key, required this.onChange});

  @override
  State<StatefulWidget> createState() => SelectionDropDownState();
}

class SelectionDropDownState extends State<SelectionDropDown> {
  List<DropdownMenuItem<String>> get dropdownItems {
    return [
      const DropdownMenuItem(value: "Paysage", child: Text("Paysage")),
      const DropdownMenuItem(value: "Portrait", child: Text("Portrait")),
    ];
  }

  String selectedValue = "Paysage";

  void setValue(String val) => setState(() => selectedValue = val);

  void onChange(String? value) {
    setState(() {
      selectedValue = value ?? "Paysage";
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      node.unfocus();
      widget.onChange(selectedValue);
    });
  }

  FocusNode node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text("Orientation:",
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        Expanded(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  focusNode: node,
                  value: selectedValue,
                  items: dropdownItems,
                  onChanged: onChange,
                  icon: const Icon(Icons.arrow_drop_down),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
