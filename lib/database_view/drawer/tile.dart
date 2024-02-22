import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode/barcode.dart';
import 'package:etiquette/database/basket.dart';
import 'package:etiquette/database/preferences.dart';
import 'package:etiquette/database/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DrawerTile extends StatelessWidget {
  final Product product;
  final ProductSelection selection;
  final void Function() onWantRemove;

  const DrawerTile({super.key, required this.product, required this.selection, required this.onWantRemove});

  Color get toxicityColor {
    if (product.toxicity >= Preferences().toxicityColorList.length ||
        product.toxicity < 0) {
      return Colors.transparent;
    }
    return Preferences().toxicityColorList[product.toxicity];
  }

  @override
  Widget build(BuildContext context) {
    String title = "${selection.number} étiquette${selection.number > 1 ? 's' : ''} à imprimer";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            collapsedBackgroundColor: Colors.white70,
            backgroundColor: Colors.white,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            title: AutoSizeText(title, maxLines: 1, minFontSize: 8),
            subtitle: AutoSizeText(selection.landscape ? 'Paysage' : 'Portrait', maxLines: 1, minFontSize: 8),
            childrenPadding: const EdgeInsets.all(24.0),
            clipBehavior: Clip.hardEdge,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                height: 15,
                color: Colors.red,
              ),
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(width: 5, color: Colors.teal), top: BorderSide(width: 5, color: Colors.teal), right: BorderSide(width: 5, color: Colors.teal))
                ),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.libelle1, maxLines: 2),
                      Text(product.libelle2, maxLines: 2),
                      Text("Code medial: ${product.codeMedial}"),
                      Text("Quantité.: ${product.quantity}"),
                      Text("Service ${product.modality}"),
                      Text("Dotation ${product.dotation}"),
                    ],
                  ),
                ),
              ),
              Container(
                height: 20,
                margin:
                const EdgeInsets.only(bottom: 8),
                color: toxicityColor,
                child: const Center(
                    child: Text(
                        "Respecter les doses prescrites",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Visibility(
                      visible: product.abriLumiere,
                      maintainState: true,
                      maintainSize: true,
                      maintainAnimation: true,
                      child: Image.asset(
                          'images/logo/abri.png'),
                    ),
                    Visibility(
                        visible: product.fridge,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Image.asset(
                            'images/logo/frigo.png')),
                    Visibility(
                        visible: product.risque,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Image.asset(
                            'images/logo/dangeureux.png'))
                  ],
                ),
              ),
              Center(
                child: Builder(builder: (context) {
                  var svg = Barcode.code128(
                      useCode128A: true,
                      useCode128B: false,
                      useCode128C: false)
                      .toSvg(product.barCode,
                      width: 240, height: 60);
                  return SvgPicture.string(svg,
                      fit: BoxFit.contain);
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: MaterialButton(
                    onPressed: onWantRemove,
                    color: Colors.deepOrangeAccent,
                    child: const Text('Retirer'),
                  ),
                ),
              )
            ],
        ),
      ),
    );
  }

}

/*
 Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            type: MaterialType.transparency,
            child: ListTile(
              contentPadding:
              const EdgeInsets.only(left: 16.0, right: 8.0),
              tileColor: Colors.black12,
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black54)),
              dense: true,
              title: Text(product.libelle1,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: SizedBox(
                width: 40,
                child: IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                    },
                    icon: const Icon(Icons.close)),
              ),
              subtitle: Builder(builder: (context) {
                if (MediaQuery.of(context).size.width < 300) {
                  return const SizedBox.shrink();
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(product.codeMedial),
                    ),
                    Expanded(
                      child: Builder(builder: (context) {
                        var svg = Barcode.code128(
                            useCode128A: true,
                            useCode128B: false,
                            useCode128C: false)
                            .toSvg(product.barCode,
                            width: 200, height: 20);
                        return SvgPicture.string(svg,
                            fit: BoxFit.contain);
                      }),
                    )
                  ],
                );
              }),
            ),
          ),
          Text("${selection.number} élément(s) à imprimer",
              style: const TextStyle(fontStyle: FontStyle.italic))
        ],
      ),
    );
 */