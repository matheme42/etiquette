import 'package:flutter/material.dart';

class ResizeContainer extends StatefulWidget {
  final bool debug;
  final Widget? child;
  final Size? defaultSize;
  final Size? minSize;

  const ResizeContainer(
      {super.key,
      this.debug = false,
      this.child,
      this.defaultSize,
      this.minSize});

  @override
  State<StatefulWidget> createState() => ResizeContainerState();
}

class ResizeContainerState extends State<ResizeContainer> {
  double? top;
  double? left;

  bool resizing = false;

  bool overflowWidth = false;
  double _windowWidth = 600;

  double get windowWidth => _windowWidth;

  set windowWidth(double val) {
    double minWidth = widget.minSize?.width ?? 200;
    if (val < minWidth) {
      overflowWidth = true;
      return;
    }
    _windowWidth = val;
    overflowWidth = false;
  }

  bool overflowHeight = false;
  double _windowHeight = 300;

  double get windowHeight => _windowHeight;

  set windowHeight(double val) {
    double minHeight = widget.minSize?.height ?? 200;

    if (val < minHeight) {
      overflowHeight = true;
      return;
    }
    _windowHeight = val;
    overflowHeight = false;
  }

  String? _resizingMode;

  String? get resizingMode => _resizingMode;

  set resizingMode(String? val) {
    if (_resizingMode != null && val != null) return;
    _resizingMode = val;
  }

  @override
  void initState() {
    super.initState();
    Size? size = widget.defaultSize;
    if (size != null) {
      _windowWidth = size.width;
      _windowHeight = size.height;
    }
  }

  void onPointerDown() {
    if (resizingMode != null) {
      setState(() => resizing = true);
    }
  }

  void onPointerUp() => setState(() => [resizing = false, resizingMode = null]);

  void onHover(PointerMoveEvent details) {
    bool moveLeft = (left! - details.position.dx + 8 + details.delta.dx) > 0;
    bool moveTop = (top! - details.position.dy + 8 + details.delta.dy) > 0;

    bool moveRight =
        ((left! + windowWidth) - details.position.dx - 8 + details.delta.dx) <
            0;
    bool moveBottom =
        ((top! + windowHeight) - details.position.dy - 8 + details.delta.dy) <
            0;

    if (resizing) {
      setState(() {
        if (resizingMode == "left" && moveLeft) {
          double x = details.delta.dx;
          windowWidth -= x;
          if (!overflowWidth) left = left! + x;
          return;
        }
        if (resizingMode == "right" && moveRight) {
          double x = details.delta.dx;
          windowWidth += x;
          return;
        }

        if (resizingMode == "top" && moveTop) {
          double y = details.delta.dy;
          windowHeight -= y;
          if (!overflowHeight) top = top! + y;
          return;
        }
        if (resizingMode == "bottom" && moveBottom) {
          double y = details.delta.dy;
          windowHeight += y;
          return;
        }
        if (resizingMode == "topleft") {
          double y = details.delta.dy;
          double x = details.delta.dx;

          if (moveTop) {
            windowHeight -= y;
            if (!overflowHeight) top = top! + y;
          }
          if (moveLeft) {
            windowWidth -= x;
            if (!overflowWidth) left = left! + x;
          }
          return;
        }

        if (resizingMode == "topright") {
          double y = details.delta.dy;
          double x = details.delta.dx;
          if (moveTop) {
            windowHeight -= y;
            if (!overflowHeight) top = top! + y;
          }
          if (moveRight) {
            windowWidth += x;
          }
          return;
        }
        if (resizingMode == "bottomright") {
          double y = details.delta.dy;
          double x = details.delta.dx;
          if (moveBottom) windowHeight += y;
          if (moveRight) windowWidth += x;
          return;
        }
        if (resizingMode == "bottomleft") {
          double y = details.delta.dy;
          double x = details.delta.dx;
          if (moveLeft) {
            windowWidth -= x;
            if (!overflowWidth) left = left! + x;
          }
          if (moveBottom) windowHeight += y;
          return;
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant ResizeContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.minSize != null && widget.minSize != oldWidget.minSize) {
      windowHeight = widget.minSize!.height;
    }
  }

  void onExitResizeField() {
    if (resizing) return;
    setState(() => resizingMode = null);
  }

  @override
  Widget build(BuildContext context) {
    top ??= MediaQuery.of(context).size.height * 0.5 - windowHeight * 0.5;
    left ??= MediaQuery.of(context).size.width * 0.5 - windowWidth * 0.5;
    return Listener(
      onPointerMove: onHover,
      onPointerDown: (_) => onPointerDown(),
      onPointerUp: (_) => onPointerUp(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: top,
            left: left,
            child: Draggable(
                maxSimultaneousDrags: resizingMode != null ? 0 : 1,
                onDragEnd: (data) {
                  setState(() {
                    top = data.offset.dy;
                    left = data.offset.dx;
                  });
                },
                childWhenDragging: const SizedBox.shrink(),
                feedback: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: windowWidth,
                    height: windowHeight,
                    child: widget.child,
                  ),
                ),
                child: SizedBox(
                  width: windowWidth,
                  height: windowHeight,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.resizeUpLeft,
                            onEnter: (_) =>
                                setState(() => resizingMode = "topleft"),
                            onHover: (_) =>
                                setState(() => resizingMode = "topleft"),
                            onExit: (_) => onExitResizeField(),
                            child: Container(
                                height: 8,
                                width: 8,
                                color:
                                    widget.debug ? Colors.purpleAccent : null),
                          ),
                          MouseRegion(
                              cursor: SystemMouseCursors.resizeUp,
                              onEnter: (_) =>
                                  setState(() => resizingMode = "top"),
                              onHover: (_) =>
                                  setState(() => resizingMode = "top"),
                              onExit: (_) => onExitResizeField(),
                              child: Container(
                                  height: 8,
                                  width: windowWidth - 16,
                                  color: widget.debug ? Colors.green : null)),
                          MouseRegion(
                              cursor: SystemMouseCursors.resizeUpRight,
                              onEnter: (_) =>
                                  setState(() => resizingMode = "topright"),
                              onHover: (_) =>
                                  setState(() => resizingMode = "topright"),
                              onExit: (_) => onExitResizeField(),
                              child: Container(
                                  height: 8,
                                  width: 8,
                                  color: widget.debug
                                      ? Colors.purpleAccent
                                      : null)),
                        ],
                      ),
                      Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.resizeLeft,
                            onEnter: (_) =>
                                setState(() => resizingMode = "left"),
                            onHover: (_) =>
                                setState(() => resizingMode = "left"),
                            onExit: (_) => onExitResizeField(),
                            child: Container(
                                height: windowHeight - 16,
                                width: 8,
                                color: widget.debug ? Colors.orange : null),
                          ),
                          Container(
                            height: windowHeight - 16,
                            width: windowWidth - 16,
                            color: widget.debug ? Colors.red : null,
                            child: widget.child,
                          ),
                          MouseRegion(
                              onEnter: (_) =>
                                  setState(() => resizingMode = "right"),
                              onHover: (_) =>
                                  setState(() => resizingMode = "right"),
                              onExit: (_) => onExitResizeField(),
                              cursor: SystemMouseCursors.resizeRight,
                              child: Container(
                                  height: windowHeight - 16,
                                  width: 8,
                                  color: widget.debug ? Colors.orange : null)),
                        ],
                      ),
                      Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.resizeDownLeft,
                            onEnter: (_) =>
                                setState(() => resizingMode = "bottomleft"),
                            onHover: (_) =>
                                setState(() => resizingMode = "bottomleft"),
                            onExit: (_) => onExitResizeField(),
                            child: Container(
                                height: 8,
                                width: 8,
                                color:
                                    widget.debug ? Colors.purpleAccent : null),
                          ),
                          MouseRegion(
                              cursor: SystemMouseCursors.resizeDown,
                              onEnter: (_) =>
                                  setState(() => resizingMode = "bottom"),
                              onHover: (_) =>
                                  setState(() => resizingMode = "bottom"),
                              onExit: (_) => onExitResizeField(),
                              child: Container(
                                  height: 8,
                                  width: windowWidth - 16,
                                  color: widget.debug ? Colors.green : null)),
                          MouseRegion(
                              cursor: SystemMouseCursors.resizeDownRight,
                              onEnter: (_) =>
                                  setState(() => resizingMode = "bottomright"),
                              onHover: (_) =>
                                  setState(() => resizingMode = "bottomright"),
                              onExit: (_) => onExitResizeField(),
                              child: Container(
                                  height: 8,
                                  width: 8,
                                  color: widget.debug
                                      ? Colors.purpleAccent
                                      : null)),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
