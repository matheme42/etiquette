import 'package:etiquette/database/etiquette.dart';
import 'package:etiquette/database/preferences.dart';
import 'package:flutter/material.dart';

class ReferenceTicketBar extends StatefulWidget {
  final void Function() onWantRebuild;

  const ReferenceTicketBar({super.key, required this.onWantRebuild});

  @override
  State<StatefulWidget> createState() => ReferenceTicketBarState();
}

class ReferenceTicketBarState extends State<ReferenceTicketBar> {
  late TextEditingController text;
  FocusNode node = FocusNode();

  GlobalKey key = GlobalKey();
  OverlayPortalController controller = OverlayPortalController();

  @override
  void initState() {
    super.initState();
    text = TextEditingController(
        text: Preferences().publipostage.referenceEtiquette);
    node.addListener(onFocusChange);
    onChange();
  }

  void onFocusChange() {
    if (node.hasFocus && !controller.isShowing && etiquettes.isNotEmpty) {
      controller.show();
    }
  }

  @override
  void dispose() {
    node.removeListener(onFocusChange);
    super.dispose();
  }

  List<Etiquette> etiquettes = [];

  void onChange() {
    etiquettes = Preferences().etiquetteController!.etiquettes.where((e) {
      return e.name.toLowerCase().contains(text.text.trim().toLowerCase());
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    setState(() {});
  }

  void onSelectEtiquette(Etiquette etiquette) {
    Preferences().publipostage.fromEtiquette(etiquette);
    widget.onWantRebuild();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Réference de l'étiquette:"),
          ),
          Expanded(
            child: OverlayPortal(
              controller: controller,
              overlayChildBuilder: (BuildContext context) {
                RenderBox box =
                    key.currentContext!.findRenderObject() as RenderBox;
                Offset position =
                    box.localToGlobal(Offset.zero); //this is global position
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                        top: position.dy + box.size.height + 4,
                        left: position.dx,
                        child: Material(
                            type: MaterialType.transparency,
                            child: Container(
                              width: box.size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.deepPurpleAccent),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Material(
                                type: MaterialType.transparency,
                                child: EtiquetteHints(
                                    etiquettes: etiquettes,
                                    onSelect: (etiquette) {
                                      node.unfocus();
                                      text.text = etiquette.name;
                                      controller.hide();
                                      onSelectEtiquette(etiquette);
                                    },
                                    onWantUpdate: () {
                                      controller.hide();
                                      onChange();
                                    }),
                              ),
                            ))),
                  ],
                );
              },
              child: TextField(
                key: key,
                focusNode: node,
                controller: text,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0)),
                onEditingComplete: () {
                  Preferences().publipostage.referenceEtiquette = text.text;
                },
                onSubmitted: (_) {
                  Preferences().publipostage.referenceEtiquette = text.text;
                },
                onChanged: (_) {
                  onChange();
                  Preferences().publipostage.referenceEtiquette = text.text;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    if (etiquettes.isNotEmpty && !controller.isShowing) {
                      controller.show();
                    } else if (controller.isShowing &&
                        (etiquettes.isEmpty || text.text.isEmpty)) {
                      controller.hide();
                    }
                  });
                },
                onTapOutside: (_) {
                  if (node.hasFocus) {
                    node.unfocus();
                    Future.delayed(const Duration(milliseconds: 130))
                        .then((value) {
                      if (controller.isShowing) controller.hide();
                    });
                    Preferences().publipostage.referenceEtiquette = text.text;
                  }
                },
              ),
            ),
          ),
          Visibility(
            visible: text.text.isNotEmpty &&
                etiquettes
                    .where((e) =>
                        e.name.toLowerCase() == text.text.trim().toLowerCase())
                    .isEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: MaterialButton(
                color: Colors.green,
                onPressed: () {
                  var etiquette = Preferences().publipostage.toEtiquette();
                  Preferences()
                      .etiquetteController!
                      .insert(etiquette)
                      .then((value) {
                    onChange();
                  });
                },
                child: const Text('Ajouter'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EtiquetteHints extends StatelessWidget {
  final List<Etiquette> etiquettes;
  final void Function(Etiquette) onSelect;
  final void Function() onWantUpdate;

  const EtiquetteHints(
      {super.key,
      required this.etiquettes,
      required this.onSelect,
      required this.onWantUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: etiquettes.length,
          itemExtent: 80,
          itemBuilder: (context, index) {
            Etiquette etiquette = etiquettes[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black26),
                    borderRadius: BorderRadius.circular(4.0)),
                onTap: () => onSelect(etiquette),
                title: Text(
                    "${etiquette.name} (${etiquette.ticketNumberVertical * etiquette.ticketNumberHorizontal})"),
                subtitle: Text(
                    'format: ${etiquette.ticketWidth} x ${etiquette.ticketHeight}  |  '
                    'page: ${etiquette.pageWidth} x ${etiquette.pageHeight}'),
                isThreeLine: true,
                trailing: IconButton(
                  onPressed: () {
                    Preferences()
                        .etiquetteController!
                        .delete(etiquette)
                        .then((value) {
                      onWantUpdate();
                    });
                  },
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                ),
              ),
            );
          }),
    );
  }
}
