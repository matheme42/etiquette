import 'package:etiquette/preferences/publipostage/apercu.dart';
import 'package:flutter/material.dart';

import 'configuration.dart';

class Publipostage extends StatelessWidget {
  const Publipostage({super.key});

  static final GlobalKey<PreviewPrintState> previewKey = GlobalKey();

  static TextEditingController nbEtiquetteHController = TextEditingController();
  static TextEditingController nbEtiquetteWController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Preview(
              previewKey: previewKey,
              hController: nbEtiquetteHController,
              wController: nbEtiquetteWController),
          Configuration(
              onChange: () => previewKey.currentState?.update(),
              hController: nbEtiquetteHController,
              wController: nbEtiquetteWController)
        ],
      ),
    );
  }
}
