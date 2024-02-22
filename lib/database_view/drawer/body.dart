import 'package:etiquette/database/basket.dart';
import 'package:etiquette/database/product.dart';
import 'package:etiquette/database_view/drawer/tile.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class DrawerBody extends StatelessWidget {
  final void Function(ProductSelection) onWantRemove;

  const DrawerBody({super.key, required this.onWantRemove});

  @override
  Widget build(BuildContext context) {
    List data = [];
    for (var e in Basket().productSelections) {
      data.add(e.toMap());
    }
    return FractionallySizedBox(
      heightFactor: 1,
      widthFactor: 1,
      child: GroupedListView<dynamic, String>(
        elements: data,
        groupBy: (element) => element['id'].toString(),
        groupSeparatorBuilder: (String groupByValue) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
          );
        },
        itemBuilder: (context, dynamic element) {
          return DrawerTile(product: element['product'], selection: element['object'], onWantRemove: () => onWantRemove(element['object']));
        },
        itemComparator: (item2, item1) => (item1['product'] as Product).codeMedial.compareTo((item2['product'] as Product).codeMedial), // optional
        useStickyGroupSeparators: false, // optional
        floatingHeader: false, // option
        sort: false,
        order: GroupedListOrder.ASC, // optional
      ),
    );
  }

}