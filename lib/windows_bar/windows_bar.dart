import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:etiquette/windows_bar/windows_button.dart';
import 'package:etiquette/windows_bar/windows_hover_bar.dart';
import 'package:flutter/material.dart';

class WindowsBar extends StatelessWidget {
  final bool showButton;

  const WindowsBar({super.key, required this.showButton});

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      color: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
      child: WindowTitleBarBox(
        child: Row(
          children: [
            Expanded(child: MoveWindow(child: const WindowsHoverMenu())),
            Visibility(
              visible: showButton,
              child: const WindowButtons(),
            )
          ],
        ),
      ),
    );
  }
}
