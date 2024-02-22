import 'package:flutter/material.dart';

class PublipostageTextField extends StatefulWidget {
  final String? Function(String?)? validator;
  final String? initialValue;
  final String label;
  final String? suffixText;
  final bool isInteger;
  final bool enable;
  final void Function(String) onSubmit;
  final TextEditingController? controller;

  const PublipostageTextField(
      {super.key,
      this.validator,
      this.initialValue,
      required this.onSubmit,
      required this.label,
      this.suffixText,
      this.isInteger = false,
      this.enable = true,
      this.controller});

  @override
  State<StatefulWidget> createState() => PublipostageTextFieldState();
}

class PublipostageTextFieldState extends State<PublipostageTextField> {
  late TextEditingController controller;

  late FocusNode node;
  late String label;

  @override
  void initState() {
    super.initState();
    node = FocusNode(canRequestFocus: widget.enable);
    controller = widget.controller ?? TextEditingController();
    controller.text = widget.initialValue ?? "";
    if (widget.controller != null) {
      controller.addListener(onControllerChange);
    }
    label = widget.label;
    node.addListener(onWantValidate);
  }

  void onControllerChange() {}

  @override
  void dispose() {
    node.removeListener(onWantValidate);
    if (widget.controller != null) {
      controller.removeListener(onControllerChange);
    }
    super.dispose();
  }

  void onWantValidate() {
    context.findAncestorStateOfType<FormState>()?.validate();
    if (widget.validator?.call(controller.text) == null ||
        widget.validator == null) {
      if (!widget.isInteger) {
        controller.text = double.parse(controller.text).toStringAsFixed(2);
      }
      widget.onSubmit(controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
        SizedBox(
          width: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  onTapOutside: (_) {
                    if (node.hasFocus) {
                      node.unfocus();
                      onWantValidate();
                    }
                  },
                  onFieldSubmitted: (_) => onWantValidate(),
                  onEditingComplete: () => onWantValidate(),
                  focusNode: node,
                  enabled: widget.enable,
                  validator: widget.validator,
                  controller: controller,
                  decoration: InputDecoration(
                    errorMaxLines: 1,
                    errorStyle: const TextStyle(
                        fontSize: 12, letterSpacing: 0, height: 0.1),
                    border: const OutlineInputBorder(),
                    suffixText: widget.suffixText,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Column(
                  children: [
                    Expanded(
                        child: IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              double? val = double.tryParse(controller.text);
                              if (val != null) {
                                if (widget.isInteger) {
                                  controller.text =
                                      (val + 1).toInt().toString();
                                } else {
                                  controller.text = (val + 0.1).toString();
                                }
                              } else {
                                controller.text =
                                    "1${widget.isInteger ? "" : ".0"}";
                              }
                              onWantValidate();
                            },
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.arrow_drop_up,
                              size: 20,
                            ))),
                    Expanded(
                        child: IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              double? val = double.tryParse(controller.text);
                              if (val != null) {
                                if (widget.isInteger) {
                                  controller.text =
                                      (val - 1).toInt().toString();
                                } else {
                                  controller.text = (val - 0.1).toString();
                                }
                              } else {
                                controller.text =
                                    "1${widget.isInteger ? "" : ".0"}";
                              }
                              onWantValidate();
                            },
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              size: 20,
                            ))),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
