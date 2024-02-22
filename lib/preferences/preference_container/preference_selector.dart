import 'package:flutter/material.dart';

import '../../windows_bar/windows_button.dart';

class PreferenceSelectorRow extends StatelessWidget {
  final PageController controller;
  final void Function(int) selectPage;

  const PreferenceSelectorRow(
      {super.key, required this.controller, required this.selectPage});

  Color buttonColor(int page) {
    if (controller.positions.isEmpty) return Colors.transparent;
    if (controller.page == page) return Colors.white30;
    return Colors.transparent;
  }

  Color buttonTextColor(int page) {
    if (controller.positions.isEmpty) return const Color(0xFFF6A00C);
    if (controller.page == page) return const Color(0xFFF6A00C);
    return const Color(0xFFF6A00C);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text('Preferences',
              style: TextStyle(
                  color: Color(0xFFF6A00C), fontWeight: FontWeight.bold)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: VerticalDivider(
            color: Color(0xFFF6A00C),
            width: 2,
            thickness: 2,
          ),
        ),
        Expanded(
            child: Row(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MaterialButton(
              hoverColor: Colors.white30,
              color: buttonColor(0),
              onPressed: () {
                selectPage(0);
              },
              child: Text('Toxicités',
                  style: TextStyle(
                      color: buttonTextColor(0), fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MaterialButton(
              color: buttonColor(1),
              hoverColor: Colors.white30,
              onPressed: () {
                selectPage(1);
              },
              child: Text('Dotations',
                  style: TextStyle(
                      color: buttonTextColor(1), fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MaterialButton(
              color: buttonColor(2),
              hoverColor: Colors.white30,
              onPressed: () {
                selectPage(2);
              },
              child: Text('Publipostages',
                  style: TextStyle(
                      color: buttonTextColor(2), fontWeight: FontWeight.bold)),
            ),
          ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: MaterialButton(
                  color: buttonColor(3),
                  hoverColor: Colors.white30,
                  onPressed: () {
                    selectPage(3);
                  },
                  child: Text('Font',
                      style: TextStyle(
                          color: buttonTextColor(3), fontWeight: FontWeight.bold)),
                ),
              ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      hoverColor: Colors.red,
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(6.0)))),
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.hovered)) {
                              return closeButtonColors.mouseOver;
                            } else if (states.contains(MaterialState.pressed)) {
                              return closeButtonColors.mouseDown;
                            }
                            return closeButtonColors.normal;
                          }),
                          iconColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.hovered)) {
                              return closeButtonColors.iconMouseOver;
                            } else if (states.contains(MaterialState.pressed)) {
                              return closeButtonColors.iconMouseDown;
                            }
                            return closeButtonColors.iconNormal;
                          })),
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      })))
        ]))
      ],
    );
  }
}
