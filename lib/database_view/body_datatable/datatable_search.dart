import 'package:etiquette/database/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../../report.dart';
import '../filter/datatable_filter_search_bar.dart';

class DatatableSearch extends StatelessWidget {
  final FocusNode searchFocusNode;
  final TextEditingController searchController;
  final void Function() onChanged;
  final ProductController? productController;
  final bool lockImportButton;

  const DatatableSearch(
      {super.key,
      required this.searchFocusNode,
      required this.searchController,
      required this.onChanged,
      required this.productController,
      required this.lockImportButton});

  @override
  Widget build(BuildContext context) {
    double appHeight = MediaQuery.of(context).size.height;
    if (appHeight < 100 || MediaQuery.of(context).size.width < 250) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        Visibility(
          visible: Report.messages.isNotEmpty,
          child: InkWell(
            onTap: () => Report.showReport(context),
            child: ShakeWidget(
              shakeConstant: ShakeOpacityConstant(),
              autoPlay: true,
              enableWebMouseHover: false,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Tooltip(
                    message: "Probleme(s) detecté(s) durant l'importation",
                    child: Icon(Icons.warning_amber, color: Colors.red)),
              ),
            ),
          ),
        ),
        Expanded(
            child: TextFormField(
          autofocus: true,
          focusNode: searchFocusNode,
          controller: searchController,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              prefixIcon: const Icon(Icons.search)),
        )),
        const DatatableSearchBarFilter()
      ],
    );
  }
}
