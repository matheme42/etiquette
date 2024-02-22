import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../widget_librairies/hover_button.dart';
import 'datatable_filter_button_content.dart';

class DataTableFilterButton extends StatelessWidget {
  final AutoSizeGroup group;
  final HoverButtonGroup hoverGroup;
  final String text;
  final List<String> datas;
  final List<String> filter;
  final void Function(bool) onWantSort;
  final void Function() onChangeFilter;

  const DataTableFilterButton(
      {super.key,
      required this.group,
      required this.text,
      required this.datas,
      required this.onWantSort,
      required this.filter,
      required this.onChangeFilter,
      required this.hoverGroup});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> updateIcon = ValueNotifier(false);
    return HoverButton(
        group: hoverGroup,
        controller: OverlayPortalController(),
        margin: const EdgeInsets.only(left: 5),
        buttonContent: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder(
                    builder: (context, _, __) {
                      return Icon(filter.isNotEmpty
                          ? Icons.filter_alt
                          : Icons.filter_alt_outlined);
                    },
                    valueListenable: updateIcon,
                  ),
                  AutoSizeText(text,
                      group: group,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 8)
                ],
              ),
            ),
          ),
        ),
        buttonHeight: 46,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 350),
          height: 80 + MediaQuery.of(context).size.height / 2.5,
          child: DatatableFilterContent(
              datas: datas,
              onWantSort: onWantSort,
              filter: filter,
              onChangeFilter: () {
                updateIcon.value = !updateIcon.value;
                onChangeFilter();
              }),
        ));
  }
}
