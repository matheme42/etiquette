import 'package:flutter/material.dart';

class HoverButtonGroup {
  List<OverlayPortalController> list = [];

  void close() {
    for (var element in list) {
      element.hide();
    }
  }
}

class HoverButton extends StatefulWidget {
  final Widget child;
  final Widget buttonContent;
  final HoverButtonGroup? group;
  final double contentWidth;
  final EdgeInsets? margin;
  final OverlayPortalController? controller;
  final double buttonHeight;
  final bool debug;

  const HoverButton({
    super.key,
    required this.child,
    required this.buttonContent,
    this.group,
    this.contentWidth = 250,
    this.controller,
    required this.buttonHeight,
    this.debug = false,
    this.margin,
  });

  @override
  State<StatefulWidget> createState() => HoverButtonState();
}

class HoverButtonState extends State<HoverButton> {
  late OverlayPortalController controller;
  GlobalKey key = GlobalKey(); // declare a global key
  bool lockCloseOnButtonExit = false;
  bool lockCloseOnOverlayExit = false;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? OverlayPortalController();
    widget.group?.list.add(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) {
          lockCloseOnOverlayExit = true;
          widget.group?.close();
          controller.show();
        },
        onExit: (_) {
          lockCloseOnOverlayExit = false;
          if (lockCloseOnButtonExit) return;
          controller.hide();
        },
        child: OverlayPortal(
          controller: controller,
          overlayChildBuilder: (BuildContext context) {
            RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
            Offset position =
                box.localToGlobal(Offset.zero); //this is global position
            double additionalOffset = 0;

            MediaQueryData data = MediaQuery.of(context);
            double width = data.size.width;
            double height = data.size.height;
            if (position.dx > width * 0.5 && box.hasSize) {
              additionalOffset = widget.contentWidth -
                  box.size.width -
                  (widget.margin?.left ?? 0);
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: position.dy + widget.buttonHeight,
                  child: AbsorbPointer(
                    absorbing: true,
                    child: Container(
                      width: width,
                      height: height - (position.dy + widget.buttonHeight),
                      color: widget.debug ? Colors.red : Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                    top: position.dy + (widget.margin?.top ?? 0),
                    left: position.dx -
                        40 -
                        additionalOffset +
                        (widget.margin?.left ?? 0),
                    child: Material(
                      type: MaterialType.transparency,
                      child: MouseRegion(
                        hitTestBehavior: HitTestBehavior.translucent,
                        cursor: MouseCursor.uncontrolled,
                        onEnter: (_) => lockCloseOnButtonExit = true,
                        onExit: (_) {
                          lockCloseOnButtonExit = false;
                          if (lockCloseOnOverlayExit) return;
                          controller.hide();
                        },
                        child: Container(
                          color:
                              widget.debug ? Colors.green : Colors.transparent,
                          padding: const EdgeInsets.only(
                              left: 32.0, right: 32.0, bottom: 32.0),
                          margin: EdgeInsets.only(top: widget.buttonHeight),
                          child: SizedBox(
                            width: widget.contentWidth,
                            child: widget.child,
                          ),
                        ),
                      ),
                    )),
              ],
            );
          },
          child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(0.0),
            clipBehavior: Clip.hardEdge,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              minWidth: 50,
              hoverColor: Colors.white24,
              key: key,
              onPressed: () {},
              child: widget.buttonContent,
            ),
          ),
        ));
  }
}
