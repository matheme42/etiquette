import 'package:etiquette/preferences/publipostage/publipostage_drop_down.dart';
import 'package:etiquette/preferences/publipostage/publipostage_text_field.dart';
import 'package:etiquette/preferences/publipostage/reference_ticket_bar.dart';
import 'package:flutter/material.dart';

import '../../database/preferences.dart';

class Configuration extends StatefulWidget {
  final void Function() onChange;
  final TextEditingController hController;
  final TextEditingController wController;

  const Configuration(
      {super.key,
      required this.onChange,
      required this.hController,
      required this.wController});

  @override
  State<StatefulWidget> createState() => ConfigurationState();
}

class ConfigurationState extends State<Configuration> {
  String? validatorIsPositiveNumber(String value) {
    double? val = double.tryParse(value);
    if (val == null || val.isNaN || val.isInfinite) return "valeur incorrect";
    if (val.isNegative) return "valeur negative";
    return null;
  }

  String? checkIsIntegerNumber(String value) {
    if (int.tryParse(value) == null) return "valeur incorrect";
    return null;
  }

  String? validatorNonNullable(String? value) {
    if (value == null || value.isEmpty) return "ne peut être vide";
    return null;
  }

  String? validatorDouble(String? value) {
    String? result;

    result = validatorNonNullable(value);
    if (result != null) return result;

    result = validatorIsPositiveNumber(value!);
    if (result != null) return result;

    return result;
  }

  String? validatorInt(String? value) {
    String? result;

    result = validatorDouble(value);
    if (result != null) return result;

    result = checkIsIntegerNumber(value!);
    if (result != null) return result;

    return result;
  }

  FocusNode node = FocusNode();
  late TextEditingController text;

  @override
  void initState() {
    super.initState();
    String ref = Preferences().publipostage.referenceEtiquette;
    text = TextEditingController(text: ref);
  }

  void onChange() {
    setState(() {});
    widget.onChange();
  }

  TextEditingController largeurController = TextEditingController();
  TextEditingController hauteurController = TextEditingController();

  TextEditingController margeSup = TextEditingController();
  TextEditingController margeLat = TextEditingController();

  TextEditingController etiquetteHauteur = TextEditingController();
  TextEditingController etiquetteLargeur = TextEditingController();

  TextEditingController padVert = TextEditingController();
  TextEditingController padHor = TextEditingController();

  void onWantRebuild() {
    PublipostagePreferences pref = Preferences().publipostage;
    largeurController.text = pref.largeurPage.toStringAsFixed(2);
    hauteurController.text = pref.hauteurPage.toStringAsFixed(2);

    margeSup.text = pref.margeSuperieur.toStringAsFixed(2);
    margeLat.text = pref.margeLaterale.toStringAsFixed(2);

    etiquetteHauteur.text = pref.hauteurEtiquette.toStringAsFixed(2);
    etiquetteLargeur.text = pref.largeurEtiquette.toStringAsFixed(2);

    padVert.text = pref.pasVertical.toStringAsFixed(2);
    padHor.text = pref.pasHorizontal.toStringAsFixed(2);
    setState(() {});
    onChange();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReferenceTicketBar(onWantRebuild: onWantRebuild),
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Flexible(
                    child: PublipostageTextField(
                        validator: validatorDouble,
                        initialValue: Preferences()
                            .publipostage
                            .margeSuperieur
                            .toStringAsFixed(2),
                        onSubmit: (value) {
                          Preferences().publipostage.margeSuperieur =
                              double.parse(value);
                          onChange();
                        },
                        label: "Marge supérieur:",
                        controller: margeSup,
                        suffixText: "cm")),
                Flexible(
                    child: PublipostageTextField(
                        validator: validatorDouble,
                        initialValue: Preferences()
                            .publipostage
                            .hauteurEtiquette
                            .toStringAsFixed(2),
                        onSubmit: (value) {
                          Preferences().publipostage.hauteurEtiquette =
                              double.parse(value);
                          onChange();
                        },
                        suffixText: "cm",
                        controller: etiquetteHauteur,
                        label: "Hauteur d'étiquette:")),
              ],
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Flexible(
                    child: PublipostageTextField(
                        validator: validatorDouble,
                        initialValue: Preferences()
                            .publipostage
                            .margeLaterale
                            .toStringAsFixed(2),
                        onSubmit: (value) {
                          Preferences().publipostage.margeLaterale =
                              double.parse(value);
                          onChange();
                        },
                        label: "Marge latérale:",
                        controller: margeLat,
                        suffixText: "cm")),
                Flexible(
                    child: PublipostageTextField(
                        validator: validatorDouble,
                        initialValue: Preferences()
                            .publipostage
                            .largeurEtiquette
                            .toStringAsFixed(2),
                        onSubmit: (value) {
                          Preferences().publipostage.largeurEtiquette =
                              double.parse(value);
                          onChange();
                        },
                        suffixText: "cm",
                        controller: etiquetteLargeur,
                        label: "Largeur d'étiquette:")),
              ],
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Flexible(
                    child: PublipostageTextField(
                        validator: validatorDouble,
                        initialValue: Preferences()
                            .publipostage
                            .pasVertical
                            .toStringAsFixed(2),
                        onSubmit: (value) {
                          Preferences().publipostage.pasVertical =
                              double.parse(value);
                          onChange();
                        },
                        label: "Pas vertical:",
                        controller: padVert,
                        suffixText: "cm")),
                Flexible(
                    child: AbsorbPointer(
                  absorbing: true,
                  child: Focus(
                    descendantsAreFocusable: false,
                    canRequestFocus: false,
                    child: PublipostageTextField(
                        validator: validatorInt,
                        onSubmit: (value) {
                          Preferences().publipostage.nbEtiquetteHorizontal =
                              int.parse(value);
                          widget.onChange();
                        },
                        isInteger: true,
                        enable: false,
                        controller: widget.wController,
                        initialValue: Preferences()
                            .publipostage
                            .nbEtiquetteHorizontal
                            .toString(),
                        suffixText: "unité(s)",
                        label: "nbre d'étiquettes (horiz.):"),
                  ),
                )),
              ],
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Flexible(
                    child: PublipostageTextField(
                        validator: validatorDouble,
                        initialValue: Preferences()
                            .publipostage
                            .pasHorizontal
                            .toStringAsFixed(2),
                        onSubmit: (value) {
                          Preferences().publipostage.pasHorizontal =
                              double.parse(value);
                          onChange();
                        },
                        controller: padHor,
                        label: "Pas Horizontal:",
                        suffixText: "cm")),
                Flexible(
                    child: AbsorbPointer(
                  absorbing: true,
                  child: Focus(
                    descendantsAreFocusable: false,
                    canRequestFocus: false,
                    child: PublipostageTextField(
                        validator: validatorInt,
                        onSubmit: (value) {
                          Preferences().publipostage.nbEtiquetteVertical =
                              int.parse(value);
                          onChange();
                        },
                        initialValue: Preferences()
                            .publipostage
                            .nbEtiquetteVertical
                            .toString(),
                        suffixText: "unité(s)",
                        isInteger: true,
                        enable: false,
                        controller: widget.hController,
                        label: "nbre d'étiquettes (vert.):"),
                  ),
                )),
              ],
            ),
          ),
          Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 12.0),
              child: PublipostageDropDown(onChange: () {
                onChange();
                largeurController.text =
                    Preferences().publipostage.largeurPage.toString();
                hauteurController.text =
                    Preferences().publipostage.hauteurPage.toString();
              })),
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Flexible(
                    child: PublipostageTextField(
                        validator: validatorDouble,
                        initialValue: Preferences()
                            .publipostage
                            .largeurPage
                            .toStringAsFixed(2),
                        onSubmit: (value) {
                          Preferences().publipostage.largeurPage =
                              double.parse(value);
                          Preferences().publipostage.pageFormat =
                              "Personnaliser";
                          onChange();
                        },
                        controller: largeurController,
                        label: "Largeur de la page:",
                        suffixText: "cm")),
                Flexible(
                    child: PublipostageTextField(
                        validator: validatorDouble,
                        initialValue: Preferences()
                            .publipostage
                            .hauteurPage
                            .toStringAsFixed(2),
                        onSubmit: (value) {
                          Preferences().publipostage.hauteurPage =
                              double.parse(value);
                          Preferences().publipostage.pageFormat =
                              "Personnaliser";
                          onChange();
                        },
                        controller: hauteurController,
                        suffixText: "cm",
                        label: "Hauteur de la page:")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
