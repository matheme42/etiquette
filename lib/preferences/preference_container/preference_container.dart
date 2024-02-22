import 'dart:ui';

import 'package:etiquette/preferences/preference_container/preference_selector.dart';
import 'package:etiquette/preferences/preference_font.dart';
import 'package:etiquette/preferences/preference_liste_dotation.dart';
import 'package:etiquette/preferences/preference_liste_toxicity.dart';
import 'package:etiquette/preferences/preference_ticket_size.dart';
import 'package:flutter/material.dart';

class PreferenceContainer extends StatelessWidget {
  final PageController controller;
  final void Function(int) selectPage;

  const PreferenceContainer(
      {super.key, required this.controller, required this.selectPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 28,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
            ),
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withAlpha(240),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6.0)),
                        image: const DecorationImage(
                            image: AssetImage('images/background.png'),
                            fit: BoxFit.fitWidth)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8.0)),
                            border: Border(
                                left: BorderSide(color: Colors.black, width: 2),
                                right:
                                    BorderSide(color: Colors.black, width: 2),
                                top:
                                    BorderSide(color: Colors.black, width: 2))),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: PreferenceSelectorRow(
                                    controller: controller,
                                    selectPage: selectPage))),
                      ),
                    ),
                  )),
            ),
          ),
        ),
        Expanded(
          child: Container(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.only(left: 2.0, bottom: 2.0, right: 2.2),
            decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(8.0)),
                color: Colors.black),
            child: GestureDetector(
              onTapDown: (_) {},
              onHorizontalDragStart: (_) {},
              onVerticalDragStart: (_) {},
              child: SizedBox.expand(
                child: Material(
                  type: MaterialType.transparency,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(6.0)),
                            color: Colors.white),
                        clipBehavior: Clip.hardEdge,
                        child: const PreferenceToxicity(),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(6.0)),
                            color: Colors.white),
                        clipBehavior: Clip.hardEdge,
                        child: const PreferenceDotation(),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(6.0)),
                            color: Colors.white),
                        clipBehavior: Clip.hardEdge,
                        child: const TicketSizePreference(),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(6.0)),
                            color: Colors.white),
                        clipBehavior: Clip.hardEdge,
                        child: const PreferenceFont(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
