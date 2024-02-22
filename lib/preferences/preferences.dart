import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:etiquette/preferences/preference_container/preference_container.dart';
import 'package:etiquette/preferences/preference_font.dart';
import 'package:etiquette/preferences/preference_ticket_size.dart';
import 'package:etiquette/widget_librairies/resize_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../windows_bar/windows_button.dart';
import 'preference_liste_dotation.dart';
import 'preference_liste_toxicity.dart';

class PreferencesWindows extends StatefulWidget {
  final int initialPage;

  const PreferencesWindows({super.key, required this.initialPage});

  static show(BuildContext context, [int page = 0]) {
    showAdaptiveDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) => PreferencesWindows(initialPage: page));
  }

  @override
  State<StatefulWidget> createState() => PreferencesWindowsState();
}

class PreferencesWindowsState extends State<PreferencesWindows> {
  static late PageController controller;

  static GlobalKey globalContainerKey = GlobalKey();

  static const double _minPublipostageHeight = 450;
  static const double _minColorSectionHeight = 450;

  @override
  void initState() {
    super.initState();
    minSize = widget.initialPage == 2
        ? _minPublipostageHeight
        : _minColorSectionHeight;
    controller = PageController(initialPage: widget.initialPage);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectPage(int page) => setState(() {
    controller.jumpToPage(page);
    if (page == 2) {
      minSize = _minPublipostageHeight;
    } else {
      minSize = _minColorSectionHeight;
    }
  });

  double minSize = _minColorSectionHeight;

  AnimationController? shakeController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () => shakeController?.forward(from: 0),
            child: FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 1,
              child: ShakeWidget(
                enableWebMouseHover: false,
                shakeConstant: ShakeDefaultConstant1(),
                onController: (controller) => shakeController = controller,
                child: ResizeContainer(
                  minSize: Size(597, minSize),
                  defaultSize: Size(597.8, minSize),
                  child: SizedBox.expand(
                    key: globalContainerKey,
                    child: PreferenceContainer(
                        controller: controller,
                        selectPage: selectPage
                    )
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 40,
            child: MoveWindow(),
          ),
        ),
      ],
    );
  }
}
