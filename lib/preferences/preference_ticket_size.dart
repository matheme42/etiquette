import 'package:etiquette/preferences/publipostage/publipostage.dart';
import 'package:flutter/material.dart';

class TicketSizePreference extends StatefulWidget {
  const TicketSizePreference({super.key});

  @override
  State<StatefulWidget> createState() => TicketSizePreferenceState();
}

class TicketSizePreferenceState extends State<TicketSizePreference> {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "A3", child: Text("A3")),
      const DropdownMenuItem(value: "A4", child: Text("A4")),
      const DropdownMenuItem(value: "A5", child: Text("A5")),
    ];
    return menuItems;
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onWantValidateForm() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate() == false) return;
  }

  String? validator(String? value, int mode, Size maxSize) {
    if (value == null || value.isEmpty) {
      return "valeur incorrect";
    }
    double? val = double.tryParse(value);
    if (val == null) {
      return "valeur incorrect";
    }
    if (val < 0 ||
        (val > maxSize.height.toInt() - 4 && mode == 1) ||
        (val > maxSize.width.toInt() - 4 && mode == 0)) {
      return "valeur en dehors des limites";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: const SizedBox.expand(
        child: Padding(padding: EdgeInsets.all(8.0), child: Publipostage()),
      ),
    );
  }
}
