import 'dart:ui';

import 'package:etiquette/database/basket.dart';
import 'package:etiquette/printer/printer.dart';
import 'package:flutter/material.dart';

import 'body.dart';

class ImpressionView extends StatefulWidget {
  const ImpressionView({super.key});

  @override
  State<StatefulWidget> createState() => ImpressionViewState();
}

class ImpressionViewState extends State<ImpressionView> {
  Future<void> onGeneratePreview() async {
    PrinterTicker().showPdfPreview(context);
  }

  void update() => setState(() {});

  @override
  void initState() {
    super.initState();
    Basket().addListener(update);
  }

  @override
  void dispose() {
    Basket().removeListener(update);
    super.dispose();
  }

  void onWantRemove(ProductSelection selection) {
       Basket().productSelections.remove(selection);
       if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('images/background.png'), fit: BoxFit.cover)
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.grey,
            centerTitle: true,
            title: const Text("Liste d'impression"),
            actions: [
              Visibility(
                visible: Basket().productSelections.isNotEmpty,
                child: MaterialButton(
                    onPressed: () => setState(() {
                          Basket().productSelections.clear();
                          Basket().updateSharedPreference();
                        }),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: const Text("Nettoyer")),
              )
            ],
          ),
          body: DrawerBody(onWantRemove: onWantRemove),
          bottomNavigationBar: SizedBox(
            height: 60,
            child: Visibility(
              visible: Basket().productSelections.isNotEmpty,
              child: Center(
                  child: MaterialButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.green,
                onPressed: () => onGeneratePreview(),
                child: const Text('Aperçu avant impression'),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
