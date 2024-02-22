import 'package:flutter/material.dart';

import '../widget_librairies/hover_button.dart';

class WindowsHoverButtons extends StatelessWidget {
  final HoverButtonGroup group;
  final String title;
  final List<Widget> children;

  const WindowsHoverButtons({
    super.key,
    required this.group,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return HoverButton(
        group: group,
        contentWidth: 200,
        margin: const EdgeInsets.only(left: 8),
        buttonContent: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF6A00C),
            ),
          ),
        ),
        buttonHeight: 32,
        child: Column(children: children));
  }
}
