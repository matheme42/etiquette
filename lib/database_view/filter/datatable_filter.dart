import 'package:auto_size_text/auto_size_text.dart';
import 'package:etiquette/database/filter.dart';
import 'package:etiquette/database/product_fields.dart';
import 'package:etiquette/widget_librairies/hover_button.dart';
import 'package:flutter/material.dart';

import 'datatable_filter_button.dart';

class DataTableFilter extends StatelessWidget {
  final void Function(String, bool) onWantSort;
  final void Function(String) onChangeFilter;

  const DataTableFilter(
      {super.key, required this.onWantSort, required this.onChangeFilter});

  static AutoSizeGroup group = AutoSizeGroup();
  static HoverButtonGroup hoverButtonGroup = HoverButtonGroup();
  static ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.7;

    if (MediaQuery.of(context).size.height < 250) {
      return const SizedBox.shrink();
    }
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      interactive: true,
      trackVisibility: true,
      scrollbarOrientation: ScrollbarOrientation.bottom,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SizedBox(
          height: 60,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: size < 800 ? 800 : size,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DataTableFilterButton(
                    group: group,
                    hoverGroup: hoverButtonGroup,
                    text: ProductField.lieu,
                    datas: Filter().lieu,
                    onWantSort: (r) => onWantSort(ProductField.lieu, r),
                    filter: Filter().selectedLieu,
                    onChangeFilter: () => onChangeFilter(ProductField.lieu),
                  ),
                  DataTableFilterButton(
                    group: group,
                    hoverGroup: hoverButtonGroup,
                    text: ProductField.modalite,
                    datas: Filter().modality,
                    onWantSort: (r) => onWantSort(ProductField.modalite, r),
                    filter: Filter().selectedModality,
                    onChangeFilter: () => onChangeFilter(ProductField.modalite),
                  ),
                  DataTableFilterButton(
                    group: group,
                    hoverGroup: hoverButtonGroup,
                    text: ProductField.dotation,
                    datas: Filter().dotation,
                    onWantSort: (r) => onWantSort(ProductField.dotation, r),
                    filter: Filter().selectedDotation,
                    onChangeFilter: () => onChangeFilter(ProductField.dotation),
                  ),
                  DataTableFilterButton(
                    group: group,
                    hoverGroup: hoverButtonGroup,
                    text: ProductField.toxicite,
                    datas: Filter().toxicity,
                    onWantSort: (r) => onWantSort(ProductField.toxicite, r),
                    filter: Filter().selectedToxicity,
                    onChangeFilter: () => onChangeFilter(ProductField.toxicite),
                  ),
                  DataTableFilterButton(
                    group: group,
                    hoverGroup: hoverButtonGroup,
                    text: ProductField.famille,
                    datas: Filter().family,
                    onWantSort: (r) => onWantSort(ProductField.famille, r),
                    filter: Filter().selectedFamily,
                    onChangeFilter: () => onChangeFilter(ProductField.famille),
                  ),
                  DataTableFilterButton(
                    group: group,
                    hoverGroup: hoverButtonGroup,
                    text: ProductField.sousFamille,
                    datas: Filter().subfamily,
                    onWantSort: (r) => onWantSort(ProductField.sousFamille, r),
                    filter: Filter().selectedSubfamily,
                    onChangeFilter: () =>
                        onChangeFilter(ProductField.sousFamille),
                  ),
                  DataTableFilterButton(
                    group: group,
                    hoverGroup: hoverButtonGroup,
                    text: 'Flags',
                    datas: Filter().flags,
                    onWantSort: (r) => onWantSort("Flags", r),
                    filter: Filter().selectedFlag,
                    onChangeFilter: () => onChangeFilter("Flags"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
