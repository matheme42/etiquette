import 'package:barcode/barcode.dart';
import 'package:etiquette/database/basket.dart';
import 'package:etiquette/database/preferences.dart';
import 'package:etiquette/database/product.dart';
import 'package:etiquette/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:flutter_svg/svg.dart';
import 'package:window_manager/window_manager.dart';

/// This is the stateful widget that the main application instantiates.
class ProductOverlay extends StatefulWidget {
  final Product? product;
  final bool selected;
  final Function(Product, int) onAddedProduct;
  final Function() onUnSelectProduct;

  const ProductOverlay(
      {Key? key,
      required this.product,
      required this.onAddedProduct,
      required this.onUnSelectProduct,
      required this.selected})
      : super(key: key);

  @override
  State<ProductOverlay> createState() => ProductOverlayState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ProductOverlayState extends State<ProductOverlay> with WindowListener {
  double mouseX = 0;
  double mouseY = 0;

  bool lockOverlay = false;

  TextEditingController numberController = TextEditingController();
  FocusNode numberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {}

  @override
  void onWindowBlur() {
    setState(() {
      mouseX = 0;
      mouseY = 0;
    });
  }

  void onValidate() {
    if (widget.product == null || !lockOverlay) return;
    int? val = int.tryParse(numberController.text);

    numberController.clear();
    if (val == null || val == 0) {
      setState(() => cardBorder = Colors.red);
      shakeController?.forward().then((value) {
        setState(() => cardBorder = Colors.transparent);
        shakeController?.reset();
      });
      return;
    }
    setState(() => cardBorder = Colors.green);
    widget.onAddedProduct(widget.product!, val);
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      cardBorder = Colors.transparent;
      if (mounted) setState(() {});
    });
  }

  Color cardBorder = Colors.transparent;
  AnimationController? shakeController;

  bool textFieldEnable = false;

  @override
  void didUpdateWidget(covariant ProductOverlay oldWidget) {
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) textFieldEnable = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  void focusNumberField() {
    setState(() => textFieldEnable = true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      numberFocusNode.requestFocus();
    });
  }

  Color get toxicityColor {
    if (widget.product!.toxicity >= Preferences().toxicityColorList.length ||
        widget.product!.toxicity < 0) {
      return Colors.transparent;
    }
    return Preferences().toxicityColorList[widget.product!.toxicity];
  }

  Color get dotationColor {
    String dotation = widget.product!.softDotation;
    Preferences settings = Preferences();
    List<String> softDotationTextList = settings.softDotationTextList;
    if (softDotationTextList.contains(dotation)) {
      return settings.dotationColorList[softDotationTextList.indexOf(dotation)];
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    double mediaQueryHeight = MediaQuery.of(context).size.height;
    bool mouseBottom = mouseY > mediaQueryHeight * 0.5;
    bool mouseRight = moveRight;
    double topPosition = mouseY + 3 + (mouseBottom ? -340 : 0);
    if (topPosition < 0) {
      topPosition = 0;
    } else if (topPosition + 440 > mediaQueryHeight) {
      topPosition -= (topPosition + 440) - mediaQueryHeight;
    }

    bool alreadySelected = false;
    if (widget.product != null) {
      for (var e in Basket().productSelections) {
        if (e.product.barCode == widget.product!.barCode) {
          alreadySelected = true;
          break;
        }
      }
    }

    return Stack(
      children: [
        Visibility(
          visible: widget.selected,
          child: Builder(builder: (context) {
            return Listener(
              onPointerDown: (_) => widget.onUnSelectProduct(),
              child: Container(
                color: Colors.transparent,
                child: const SizedBox.expand(),
              ),
            );
          }),
        ),
        MouseRegion(
          onHover: _updateLocation,
          hitTestBehavior: HitTestBehavior.translucent,
          child: Stack(children: [
            Positioned(
              top: topPosition,
              left: mouseX + 5 + (mouseRight ? -258 : 0),
              child: AnimatedContainer(
                height: lockOverlay ? 400 : 340,
                width: 250,
                duration: const Duration(milliseconds: 300),
                onEnd: () => focusNumberField(),
                child: Visibility(
                  visible:
                      (widget.product != null || lockOverlay) && mouseX > 0,
                  child: ShakeWidget(
                    duration: const Duration(milliseconds: 300),
                    shakeConstant: ShakeDefaultConstant1(),
                    autoPlay: false,
                    enableWebMouseHover: false,
                    onController: (controller) => shakeController = controller,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(color: cardBorder, width: 2.0)),
                      color: Colors.white,
                      borderOnForeground: true,
                      child: SizedBox.expand(
                        child: Builder(builder: (context) {
                          Product product = widget.product!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        height: 20,
                                        padding: const EdgeInsets.all(4.0),
                                        margin: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 8.0),
                                        decoration: BoxDecoration(
                                            color: dotationColor,
                                            border: Border.all(
                                                color: Colors.grey, width: 2))),
                                  ),
                                  Visibility(
                                    visible: alreadySelected,
                                    child: SizedBox(
                                      width: 80,
                                      child: Badge(
                                        offset: const Offset(-70, -4),
                                        backgroundColor: Colors.red,
                                        isLabelVisible: alreadySelected,
                                        alignment: Alignment.topRight,
                                        label: const Text("Déjà ajouter"),
                                        child: Container(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                  top: BorderSide(
                                      width: 6.0, color: Colors.teal),
                                  left: BorderSide(
                                      width: 6.0, color: Colors.teal),
                                  right: BorderSide(
                                      width: 6.0, color: Colors.teal),
                                )),
                                margin: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Builder(builder: (context) {
                                          String libelle1 =
                                              product.libelle1.toUpperCase();
                                          String libelle2 =
                                              product.libelle2.toUpperCase();
                                          return Text(
                                              "$libelle1 / $libelle2\n\n",
                                              maxLines: 3,
                                              textScaler:
                                                  const TextScaler.linear(1.1));
                                        }),
                                        Text(
                                            "ART.: ${product.codeMedial.toUpperCase()}"),
                                        Text("QUA.: ${product.quantity}"),
                                        Text("SERVICE / ${product.modality}"),
                                        Text(product.dotation)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 20,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                color: toxicityColor,
                                child: const Center(
                                    child: Text(
                                        "Respecter les doses prescrites",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))),
                              ),
                              SizedBox(
                                height: 60,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Visibility(
                                          visible: product.abriLumiere,
                                          maintainState: true,
                                          maintainSize: true,
                                          maintainAnimation: true,
                                          child: Image.asset(
                                              'images/logo/abri.png'),
                                        ),
                                        Visibility(
                                            visible: product.fridge,
                                            maintainState: true,
                                            maintainSize: true,
                                            maintainAnimation: true,
                                            child: Image.asset(
                                                'images/logo/frigo.png')),
                                        Visibility(
                                            visible: product.risque,
                                            maintainState: true,
                                            maintainSize: true,
                                            maintainAnimation: true,
                                            child: Image.asset(
                                                'images/logo/dangeureux.png'))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Builder(builder: (context) {
                                  var svg = Barcode.code128(
                                          useCode128A: true,
                                          useCode128B: false,
                                          useCode128C: false)
                                      .toSvg(product.barCode,
                                          width: 200, height: 80);
                                  return SvgPicture.string(svg,
                                      fit: BoxFit.contain);
                                }),
                              ),
                              AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: lockOverlay ? 60 : 0,
                                  onEnd: () {},
                                  child: FractionallySizedBox(
                                    widthFactor: 1,
                                    child: Visibility(
                                      visible: lockOverlay,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        child: Form(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: TextFormField(
                                                focusNode: numberFocusNode,
                                                controller: numberController,
                                                autofocus: false,
                                                enabled: textFieldEnable,
                                                decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(),
                                                    suffixText: 'Unité(s)',
                                                    hintText: textFieldEnable
                                                        ? "1"
                                                        : ""),
                                                keyboardType:
                                                    TextInputType.number,
                                              )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: MaterialButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0)),
                                                    onPressed: onValidate,
                                                    color: Colors.green,
                                                    child:
                                                        const Text('Ajouter')),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ],
    );
  }

  bool moveRight = false;

  void _updateLocation(PointerHoverEvent event) {
    if (lockOverlay) return;
    if (event.delta.dx.abs() > 2) {
      moveRight = mouseX < event.localPosition.dx;
    }
    setState(() {
      mouseX = event.localPosition.dx;
      mouseY = event.localPosition.dy;
    });
  }
}
