import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:etiquette/widget_librairies/resize_container.dart';
import 'package:etiquette/windows_bar/windows_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../database/product.dart';
import 'list.dart';

class SelectionProducts extends StatefulWidget {
  final List<Product> products;

  const SelectionProducts({super.key, required this.products});

  static Future<dynamic> show(
      BuildContext context, List<Product> products) async {
    return await showAdaptiveDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) => SelectionProducts(products: products));
  }

  @override
  State<StatefulWidget> createState() => SelectionProductsState();
}

class SelectionProductsState extends State<SelectionProducts> {
  static GlobalKey globalContainerKey = GlobalKey();
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
                  minSize: const Size(597, 300),
                  defaultSize: const Size(597.8, 450),
                  child: SizedBox.expand(
                    key: globalContainerKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 28,
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8.0)),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: 1,
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(240),
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(6.0)),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                'images/background.png'),
                                            fit: BoxFit.fitWidth)),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 8, sigmaY: 8),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(8.0)),
                                            border: Border(
                                                left: BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                right: BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                top: BorderSide(
                                                    color: Colors.black,
                                                    width: 2))),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0),
                                                    child: Text('Selections',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFF6A00C),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Expanded(
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: IconButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              hoverColor:
                                                                  Colors.red,
                                                              style:
                                                                  ButtonStyle(
                                                                      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.only(
                                                                              topRight: Radius.circular(
                                                                                  6.0)))),
                                                                      backgroundColor:
                                                                          MaterialStateProperty.resolveWith(
                                                                              (states) {
                                                                        if (states.contains(MaterialState
                                                                            .hovered)) {
                                                                          return closeButtonColors
                                                                              .mouseOver;
                                                                        } else if (states
                                                                            .contains(MaterialState.pressed)) {
                                                                          return closeButtonColors
                                                                              .mouseDown;
                                                                        }
                                                                        return closeButtonColors
                                                                            .normal;
                                                                      }),
                                                                      iconColor:
                                                                          MaterialStateProperty.resolveWith(
                                                                              (states) {
                                                                        if (states.contains(MaterialState
                                                                            .hovered)) {
                                                                          return closeButtonColors
                                                                              .iconMouseOver;
                                                                        } else if (states
                                                                            .contains(MaterialState.pressed)) {
                                                                          return closeButtonColors
                                                                              .iconMouseDown;
                                                                        }
                                                                        return closeButtonColors
                                                                            .iconNormal;
                                                                      })),
                                                              icon: const Icon(
                                                                  Icons.close,
                                                                  size: 20),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              })))
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            padding: const EdgeInsets.only(
                                left: 2.0, bottom: 2.0, right: 2.2),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(8.0)),
                                color: Colors.black),
                            child: GestureDetector(
                              onTapDown: (_) {},
                              onHorizontalDragStart: (_) {},
                              onVerticalDragStart: (_) {},
                              child: SizedBox.expand(
                                child: Material(
                                    type: MaterialType.transparency,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(6))),
                                      child: SelectionList(
                                          products: widget.products),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
