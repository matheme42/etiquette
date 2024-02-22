import 'package:etiquette/database/preferences.dart';
import 'package:flutter/material.dart';

class PublipostageDropDown extends StatefulWidget {
  final void Function() onChange;

  const PublipostageDropDown({super.key, required this.onChange});

  @override
  State<StatefulWidget> createState() => PublipostageDropDownState();
}

class PublipostageDropDownState extends State<PublipostageDropDown> {
  List<DropdownMenuItem<String>> get dropdownItems {
    return [
      const DropdownMenuItem(
          value: "Personnaliser", child: Text("Personnaliser")),
      const DropdownMenuItem(value: "Lettre", child: Text("Lettre")),
      const DropdownMenuItem(value: "Lettre US", child: Text("Lettre US")),
      const DropdownMenuItem(value: "A3", child: Text("A3")),
      const DropdownMenuItem(value: "Paysage A3", child: Text("Paysage A3")),
      const DropdownMenuItem(value: "A4", child: Text("A4")),
      const DropdownMenuItem(value: "Paysage A4", child: Text("Paysage A4")),
      const DropdownMenuItem(value: "A5", child: Text("A5")),
      const DropdownMenuItem(value: "Paysage A5", child: Text("Paysage A5")),
      const DropdownMenuItem(value: "A6", child: Text("A6")),
      const DropdownMenuItem(value: "Paysage A6", child: Text("Paysage A6")),
      const DropdownMenuItem(value: "JIS B5", child: Text("JIS B5")),
      const DropdownMenuItem(value: "Mini", child: Text("Mini")),
      const DropdownMenuItem(
          value: "Demi-page verticale", child: Text("Demi-page verticale")),
      const DropdownMenuItem(
          value: "Paysage demi-page verticale",
          child: Text("Paysage demi-page verticale")),
      const DropdownMenuItem(value: "Hagaki", child: Text("Hagaki")),
      const DropdownMenuItem(
          value: "Paysage Hagaki", child: Text("Paysage Hagaki")),
      const DropdownMenuItem(value: "JIS B4", child: Text("JIS B4")),
    ];
  }

  void onChange(String? value) {
    setState(() => Preferences().publipostage.pageFormat = value!);
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onChange());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 16.0, left: 8.0),
          child: Text("Taille de la page:",
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
                  value: Preferences().publipostage.pageFormat,
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
