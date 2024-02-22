import 'package:flutter/material.dart';

class SelectionTextField extends StatefulWidget {
  final TextEditingController controller;
  final void Function()? onChange;

  const SelectionTextField(
      {super.key, required this.controller, this.onChange});

  @override
  State<StatefulWidget> createState() => SelectionTextFieldState();
}

class SelectionTextFieldState extends State<SelectionTextField> {
  int height = 30;
  int width = 160;

  FocusNode node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.toDouble(),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('nombres:'),
          ),
          Expanded(
            child: SizedBox(
              height: height.toDouble(),
              child: TextFormField(
                focusNode: node,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() => [height = 40, width = 220]);
                    return "ne peut pas etre vide";
                  }
                  int? val = int.tryParse(value);
                  if (val == null || val <= 0) {
                    setState(() => [height = 40, width = 220]);
                    return "valeur incorrect";
                  }
                  setState(() => [height = 30, width = 160]);
                  return null;
                },
                controller: widget.controller,
                onEditingComplete: () => widget.onChange?.call(),
                onFieldSubmitted: (_) => widget.onChange?.call(),
                onTapOutside: (_) {
                  if (node.hasFocus == false) return;
                  widget.onChange?.call();
                  node.unfocus();
                },
                onChanged: (_) => widget.onChange?.call(),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(letterSpacing: 0, fontSize: 10, height: 0.1),
                    contentPadding: EdgeInsets.only(left: 8.0)),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            width: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          double? val = double.tryParse(widget.controller.text);
                          if (val != null) {
                            if (val <= 0) {
                              widget.controller.text = "1";
                            } else {
                              widget.controller.text =
                                  (val + 1).toInt().toString();
                            }
                          } else {
                            widget.controller.text = "1";
                          }
                          widget.onChange?.call();
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
                          double? val = double.tryParse(widget.controller.text);
                          if (val != null) {
                            widget.controller.text =
                                (val - 1).toInt().toString();
                            if ((val - 1).toInt() <= 0) {
                              widget.controller.text = "1";
                            }
                          } else {
                            widget.controller.text = "1";
                          }
                          widget.onChange?.call();
                        },
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
