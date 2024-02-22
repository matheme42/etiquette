import 'dart:math';

import 'package:flutter/material.dart';

import '../../database/preferences.dart';

class Preview extends StatelessWidget {
  final GlobalKey<PreviewPrintState>? previewKey;
  final TextEditingController hController;
  final TextEditingController wController;

  const Preview(
      {super.key,
      this.previewKey,
      required this.hController,
      required this.wController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Aperçu'),
            ),
            Expanded(child: Divider(color: Colors.black38, thickness: 1)),
          ]),
        ),
        Container(
          height: 300,
          decoration: BoxDecoration(border: Border.all()),
          child: PreviewPrint(
              key: previewKey,
              hController: hController,
              wController: wController),
        )
      ],
    );
  }
}

class PreviewPrint extends StatefulWidget {
  final TextEditingController hController;
  final TextEditingController wController;

  const PreviewPrint(
      {super.key, required this.hController, required this.wController});

  @override
  State<StatefulWidget> createState() => PreviewPrintState();
}

class PreviewPrintState extends State<PreviewPrint> {
  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    PublipostagePreferences pref = Preferences().publipostage;
    Size size = Size(pref.largeurPage * 10, pref.hauteurPage * 10);
    double aspectRatio = 1 / size.aspectRatio;

    int precision = 10000;

    double proportionMargeLateral =
        ((pref.margeLaterale * 10) / size.width) * precision;
    double proportionMargeLateralInverse = precision - proportionMargeLateral;

    double proportionMargeSuperieur =
        ((pref.margeSuperieur * 10) / size.height) * precision;
    double proportionMargeSuperieurInverse =
        precision - proportionMargeSuperieur;

    double pasVertical = max(pref.pasVertical, pref.hauteurEtiquette) * 10;
    double pasHorizontal = max(pref.pasHorizontal, pref.largeurEtiquette) * 10;

    double ticketHeight = (pasVertical / size.height);
    double ticketWidth = (pasHorizontal / size.width);

    if (ticketHeight == 0 || ticketWidth == 0) return const SizedBox.expand();

    double workAreaWidth = (proportionMargeLateralInverse / precision);
    double workAreaHeight = (proportionMargeSuperieurInverse / precision);

    int ticketNumberWidth = workAreaWidth ~/ ticketWidth;
    int ticketNumberHeight = workAreaHeight ~/ ticketHeight;

    Preferences().publipostage.nbEtiquetteHorizontal = ticketNumberWidth;
    Preferences().publipostage.nbEtiquetteVertical = ticketNumberHeight;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.wController.text = ticketNumberWidth.toString();
      widget.hController.text = ticketNumberHeight.toString();
    });
    double deadMarginHeight =
        (workAreaHeight - (ticketHeight * ticketNumberHeight)) * precision;
    double deadMarginHeightInverse = precision - deadMarginHeight;

    workAreaHeight -= deadMarginHeight / precision;

    double deadMarginWidth =
        (workAreaWidth - (ticketWidth * ticketNumberWidth)) * precision;
    double deadMarginWidthInverse = precision - deadMarginWidth;
    workAreaWidth -= deadMarginWidth / precision;

    if (ticketNumberHeight < 0) ticketNumberHeight = 0;
    if (ticketNumberWidth < 0) ticketNumberWidth = 0;

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: Center(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  border: Border.all(),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: proportionMargeSuperieur.ceil(),
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                    Flexible(
                        flex: proportionMargeSuperieurInverse.floor(),
                        child: Column(
                          children: [
                            Flexible(
                              flex: proportionMargeLateral.ceil(),
                              child: Container(
                                color: Colors.grey,
                              ),
                            ),
                            Flexible(
                              flex: proportionMargeLateralInverse.floor(),
                              child: Container(
                                color: Colors.transparent,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: deadMarginHeightInverse.floor(),
                                        child: Column(
                                          children: [
                                            Flexible(
                                              flex: deadMarginWidthInverse
                                                  .floor(),
                                              child: Stack(
                                                alignment: Alignment.topLeft,
                                                fit: StackFit.expand,
                                                children: buildTicketPreview(
                                                    ticketNumberWidth:
                                                        ticketNumberWidth,
                                                    ticketNumberHeight:
                                                        ticketNumberHeight,
                                                    ticketHeight: ticketHeight,
                                                    ticketWidth: ticketWidth,
                                                    pref: pref,
                                                    pasHorizontal:
                                                        pasHorizontal,
                                                    pasVertical: pasVertical,
                                                    workAreaWidth:
                                                        workAreaWidth,
                                                    workAreaHeight:
                                                        workAreaHeight),
                                              ),
                                            ),
                                            Flexible(
                                                flex: deadMarginWidth.ceil(),
                                                child: Container(
                                                  color: Colors.grey,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                          flex: deadMarginHeight.ceil(),
                                          child: Container(
                                            color: Colors.grey,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  List<Widget> buildTicketPreview(
      {required int ticketNumberWidth,
      required int ticketNumberHeight,
      required double ticketWidth,
      required double ticketHeight,
      required double workAreaWidth,
      required double workAreaHeight,
      required double pasHorizontal,
      required double pasVertical,
      required PublipostagePreferences pref}) {
    int len = ticketNumberHeight * ticketNumberWidth;
    return List<Widget>.generate(len, (index) {
      double x = 0;
      if (ticketNumberHeight > 1) {
        x = ((index % ticketNumberHeight) / (ticketNumberHeight - 1)) * 2;
      }
      double y = 0;

      if (ticketNumberWidth > 1) {
        double stepY = 2 / (ticketNumberWidth - 1);
        y = index ~/ ticketNumberHeight * stepY;
      }
      return FractionallySizedBox(
        alignment: Alignment(-1 + x, -1 + y),
        heightFactor: ticketWidth / workAreaWidth,
        widthFactor: ticketHeight / workAreaHeight,
        child: Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            heightFactor: pref.largeurEtiquette / (pasHorizontal / 10),
            widthFactor: pref.hauteurEtiquette / (pasVertical / 10),
            child: Container(
              decoration:
                  BoxDecoration(color: Colors.white, border: Border.all()),
            ),
          ),
        ),
      );
    });
  }
}
