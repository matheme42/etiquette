import 'package:etiquette/database/basket.dart';
import 'package:etiquette/preferences/preferences.dart';
import 'package:etiquette/widget_librairies/hover_button.dart';
import 'package:etiquette/windows_bar/windows_button.dart';
import 'package:etiquette/windows_bar/windows_hover_buttons.dart';
import 'package:flutter/material.dart';

import '../database/preferences.dart';
import '../printer/printer.dart';

class CheckboxMenuTile extends StatelessWidget {
  final String title;
  final void Function(bool val) onTap;
  final bool value;

  const CheckboxMenuTile(
      {super.key,
      required this.title,
      required this.onTap,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      visualDensity: VisualDensity.compact,
      dense: true,
      tileColor: Colors.black87,
      hoverColor: Colors.white24,
      controlAffinity: ListTileControlAffinity.trailing,
      title: Text(title, style: TextStyle(color: buttonColors.mouseOver)),
      value: value,
      onChanged: (bool? value) {
        context
            .findAncestorWidgetOfExactType<WindowsHoverButtons>()
            ?.group
            .close();
        onTap(value ?? false);
      },
    );
  }
}

class MenuTile extends StatelessWidget {
  final String shortcut;
  final String title;
  final void Function() onTap;

  const MenuTile(
      {super.key,
      required this.shortcut,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      dense: true,
      tileColor: Colors.black87,
      titleTextStyle: TextStyle(color: buttonColors.mouseOver),
      hoverColor: Colors.white24,
      trailing: Text(shortcut, style: const TextStyle(color: Colors.grey)),
      title: Text(title),
      onTap: () {
        context
            .findAncestorWidgetOfExactType<WindowsHoverButtons>()
            ?.group
            .close();
        onTap();
      },
    );
  }
}

class MenuNotification extends Notification {
  final int id;

  MenuNotification(this.id);
}

class WindowsHoverMenu extends StatefulWidget {
  const WindowsHoverMenu({super.key});

  @override
  State<StatefulWidget> createState() => WindowsHoverMenuState();
}

class WindowsHoverMenuState extends State<WindowsHoverMenu> {
  HoverButtonGroup group = HoverButtonGroup();
  ScrollController controller = ScrollController();

  void onBasketChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Preferences().addListener(onBasketChange);
    Basket().addListener(onBasketChange);
  }

  @override
  void dispose() {
    Preferences().removeListener(onBasketChange);
    Basket().removeListener(onBasketChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLabelVisible = Basket().productSelections.isNotEmpty;
    return RawScrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            WindowsHoverButtons(group: group, title: 'File', children: [
              MenuTile(
                  shortcut: 'CTRL-I',
                  title: 'Importer',
                  onTap: () {
                    MenuNotification(1).dispatch(context);
                  }),
              MenuTile(
                  shortcut: 'CTRL-T',
                  title: 'Tester',
                  onTap: () {
                    MenuNotification(2).dispatch(context);
                  }),
            ]),
            WindowsHoverButtons(group: group, title: 'Preferences', children: [
              CheckboxMenuTile(
                  title: 'Overlay',
                  onTap: (val) {
                    setState(() => Preferences().showOverlay = val);
                  },
                  value: Preferences().showOverlay),
              MenuTile(
                  shortcut: 'CTRL-1',
                  title: 'Toxicités',
                  onTap: () => PreferencesWindows.show(context)),
              MenuTile(
                  shortcut: 'CTRL-2',
                  title: "Dotations",
                  onTap: () => PreferencesWindows.show(context, 1)),
              MenuTile(
                  shortcut: 'CTRL-3',
                  title: "Publipostage",
                  onTap: () => PreferencesWindows.show(context, 2)),
              MenuTile(
                  shortcut: 'CTRL-4',
                  title: "Font",
                  onTap: () => PreferencesWindows.show(context, 3)),
            ]),
            Badge(
                textColor: isLabelVisible ? Colors.white : Colors.transparent,
                backgroundColor:
                    isLabelVisible ? Colors.red : Colors.transparent,
                label: Text(Basket().productSelections.length.toString()),
                child: WindowsHoverButtons(
                    group: group,
                    title: 'Impressions',
                    children: [
                      Badge(
                          textColor: isLabelVisible
                              ? Colors.white
                              : Colors.transparent,
                          backgroundColor:
                              isLabelVisible ? Colors.red : Colors.transparent,
                          label: Text(
                              Basket().productSelections.length.toString()),
                          child: MenuTile(
                              shortcut: 'CTRL-B',
                              title: "Liste",
                              onTap: () {
                                MenuNotification(0).dispatch(context);
                              })),
                      MenuTile(
                          shortcut: 'CTRL-E',
                          title: 'Aperçu',
                          onTap: () {
                            if (Basket().productSelections.isNotEmpty) {
                              PrinterTicker().showPdfPreview(context, true);
                              return;
                            }
                            var messenger = ScaffoldMessenger.of(context);
                            messenger.clearSnackBars();
                            var snackBar = const SnackBar(
                                content: Text("Rien a previsualiser"));
                            messenger.showSnackBar(snackBar);
                          }),
                      MenuTile(
                          shortcut: 'CTRL-P',
                          title: 'Imprimer',
                          onTap: () {
                            if (Basket().productSelections.isNotEmpty) {
                              PrinterTicker().printPdf(context);
                              return;
                            }
                            var messenger = ScaffoldMessenger.of(context);
                            messenger.clearSnackBars();
                            var snackBar = const SnackBar(
                                content: Text("Rien a imprimer"));
                            messenger.showSnackBar(snackBar);
                          }),
                      MenuTile(
                          shortcut: 'CTRL-N',
                          title: 'Nettoyer',
                          onTap: () {
                            Basket().productSelections.clear();
                            Basket().updateSharedPreference();
                          }),
                    ])),
          ],
        ),
      ),
    );
  }
}
